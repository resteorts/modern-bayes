## general dirichlet sampler 
#4 dirichlet function
rdirichlet <- function(n, alpha) {
  k <- length(alpha)
  y <- matrix(rgamma(n * k, shape = alpha, rate = 1), ncol = k, byrow = TRUE)
  y / rowSums(y)
}

## convert to triangle coordinates
to_xy <- function(theta) {
  x <- theta[,2] + 0.5 * theta[,3]
  y <- (sqrt(3)/2) * theta[,3]
  cbind(x, y)
}

## values of alpha
alpha_list <- list(
  c(1,1,1),
  c(2,2,2),
  c(5,5,5),
  c(2,5,5),
  c(2,2,5),
  c(0.7,0.7,0.7)
)

titles <- c(
  "Dirichlet(1,1,1)",
  "Dirichlet(2,2,2)",
  "Dirichlet(5,5,5)",
  "Dirichlet(2,5,5)",
  "Dirichlet(2,2,5)",
  "Dirichlet(0.7,0.7,0.7)"
)

## set up plot
par(mfrow = c(2,3), mar = c(2,2,3,1))
n <- 2000

## loop over sampler and coordinates
for(i in 1:6) {
  samples <- rdirichlet(n, alpha_list[[i]])
  coords <- to_xy(samples)
  
  # empty simplex plot
  plot(NA, xlim = c(0,1), ylim = c(0, sqrt(3)/2),
       xlab = "", ylab = "", axes = FALSE, asp = 1,
       main = titles[i])
  
  # triangle
  polygon(c(0,1,0.5), c(0,0,sqrt(3)/2))
  
  # plot the coordinates
  points(coords, pch = 16, cex = 0.5)
}

## update to give heatmap of the points
## provide heatmaps on the 2D simplex, 
## ignore shading outside of the triangle
nx <- 200
ny <- 200
x_vals <- seq(0, 1, length.out = nx)
y_vals <- seq(0, sqrt(3)/2, length.out = ny)

TH1 <- TH2 <- TH3 <- matrix(NA_real_, nrow = nx, ncol = ny)
tol <- 1e-6

for (i in 1:nx) {
  for (j in 1:ny) {
    x <- x_vals[i]
    y <- y_vals[j]
    
    # invert (x,y) -> (theta1, theta2, theta3)
    theta3 <- 2 * y / sqrt(3)
    theta2 <- x - 0.5 * theta3
    theta1 <- 1 - theta2 - theta3
    
    if (theta1 > tol && theta2 > tol && theta3 > tol &&
        theta1 < 1 + tol && theta2 < 1 + tol && theta3 < 1 + tol) {
      TH1[i, j] <- theta1
      TH2[i, j] <- theta2
      TH3[i, j] <- theta3
    } else {
      TH1[i, j] <- NA
      TH2[i, j] <- NA
      TH3[i, j] <- NA
    }
  }
}

## alpha values 
alpha_list <- list(
  c(1, 1, 1),
  c(2, 2, 2),
  c(5, 5, 5),
  c(2, 5, 5),
  c(2, 2, 5),
  c(0.7, 0.7, 0.7)  # interpreted from (0.7, 0.7, 0.7)
)

titles <- c(
  "Dirichlet(1,1,1)",
  "Dirichlet(2,2,2)",
  "Dirichlet(5,5,5)",
  "Dirichlet(2,5,5)",
  "Dirichlet(2,2,5)",
  "Dirichlet(0.7,0.7,0.7)"
)

## plot the updates 
par(mfrow = c(2, 3), mar = c(2, 2, 3, 1))

for (k in seq_along(alpha_list)) {
  alpha <- alpha_list[[k]]
  
  # Dirichlet normalizing constant (log-scale)
  logC <- lgamma(sum(alpha)) - sum(lgamma(alpha))
  
  # compute density on the simplex grid
  Z <- exp(
    logC +
      (alpha[1] - 1) * log(TH1) +
      (alpha[2] - 1) * log(TH2) +
      (alpha[3] - 1) * log(TH3)
  )
  
# image() ignores NA, so color appears only inside the triangle
  image(x_vals, y_vals, Z,
        xlab = "", ylab = "", axes = FALSE, asp = 1,
        main = titles[k])
  
  # draw simplex boundary
  polygon(c(0, 1, 0.5), c(0, 0, sqrt(3)/2))
  
  # label corners: theta_1, theta_2, theta_3
  text(0, 0, expression(theta[1]), pos = 1, cex = 1.4)
  text(1, 0, expression(theta[2]), pos = 1, cex = 1.4)
  text(0.5, sqrt(3)/2, expression(theta[3]), pos = 3, cex = 1.4)
}




