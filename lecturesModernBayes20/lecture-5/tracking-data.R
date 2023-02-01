#playing around with an importance sampling example


# simulate a uniform density 

uniform_simulation <- runif(n=10^10, min=0, max=1)
hist(uniform_simulation)
mean(uniform_simulation)
var(uniform_simulation)

# simulate normal(0,1) data and compare to the dnorm density

## simulated density
x <- seq(-3,3,length.out=10)
hist(rnorm(x), freq=FALSE, main="", xlab = "x-values")
## true density
curve(dnorm(x, mean = 0, sd = 1),
      from = -3,
      to = 3,
      add = TRUE,
      col = "blue",
      xlab = "x-values")


theta <- rcauchy(10, 36, 0.02)  
likelihood <- apply(as.matrix(theta), 1, dcauchy, latitude, 0.002)
posterior <- sapply()

# generate the likelihood from the data and simulated theta_i





# example simulate a cauchy distribution and compare to the one in R. 

# this will return a value from the prior on the cauchy



#cauchy_like <- function(theta, s=0.002){
  #return(dcauchy(theta, s))
#}

# let's simulate the cauchy likelihood and compare to the true one

simulations <- 100
theta <- seq(30, 40, length.out = simulations)
plot(theta, rcauchy(theta, 36.07, 0.02)) #Prior distribution (cauchy)


cauchy_like <- rcauchy(simulations, theta, 0.002)
hist(cauchy_like)



cauchy_prior <- function(simulations, theta_not = 36.07, s_not = 0.02){
  return(rcauchy(simulations, theta_not, s_not))
}




theta <- cauchy_prior(simulations = 10, 36,0.02)
cauchy_like(theta)


(marginal <- theta*cauchy_like(theta))

 


monte_carlo <- function(x){
  return(dnorm(x))
}

draws <- rnorm(10000)
monte_carlo_approximation <- sapply(draws, monte_carlo)
hist(monte_carlo_approximation)










latitude <- c(36.077916, 36.078032, 36.078129, 36.078048,
              36.077942, 36.089612, 36.077789, 36.077563)

longitude <- c(79.009266, 79.009180,  79.009094, 79.008891,
               79.008962, 79.035760, 79.008917, 79.009281)

hist(latitude)

#draw one monte carlo sample

(theta <- rcauchy(1, 36.07, 0.02)) # simulate a value of theta
(x <- dcauchy(theta, 0.002)) #simulate a value of the likelihood

## data point is latitude, which has a cauchy distribution
## prior theta has a cauchy but is not conjugate
## first make a monte carlo update

simulation <- 10000
theta <- rcauchy(simulation, 36.07, 0.02)
test <- 1/simulation*dcauchy(latitude, theta, 0.002)
plot(log(1:simulation), test)

x = apply(as.matrix(theta), rcauchy, n = 1, 0.002)



theta <- seq(30,40, length.out=100)
# given the data
data <- dcauchy(latitude, theta, 0.0002)
# put a prior on theta
prior <- dcauchy(36.07, 0.02)

# need to estimate the marginal distriubtion p(x)



simulations <- 1000
theta_simulations <- rcauchy(simulations, 36.07, 0.02)
likelihood_simulations <- rcauchy(simulations, location=theta_simulations, 0.002)
plot(seq(1:simulations), marginal, type="l")

marginal_like = function(simulations = 1000){
  theta_simulations <- rcauchy(simulations, 36.07, 0.02)
  marginal <- apply(as.matrix(theta_simulations), 1, rcauchy, 0.002)
  mean(marginal)
}



# compute the posterior risk given c 
# s is the number of random draws 
posterior_risk = function(c, a_prior, b_prior, sum_x, n, s = 30000){
  # randow draws from beta distribution 
  a_post = a_prior + sum_x
  b_post = b_prior + n - sum_x
  theta = rbeta(s, a_post, b_post)
  loss <- apply(as.matrix(theta),1,loss_function,c)
  # average values from the loss function
  risk = mean(loss)
}
# a sequence of c in [0, 0.5]
c = seq(0, 0.5, by = 0.01)
post_risk <- apply(as.matrix(c),1,posterior_risk, a, b, sum_x, n)
head(post_risk)

