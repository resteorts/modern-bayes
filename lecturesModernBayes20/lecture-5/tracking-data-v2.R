# Example of Monte Carlo Simulation of Ratios

# This is an example taken from here: https://jwmi.github.io/BMS/chapter5-monte-carlo.pdf

n_prod = 1011
n_nonprod = 860
x_prod = 353
x_nonprod = 441

# these are the posterior updates
theta_prod <- dbeta(n_prod, 354, 659)
theta_nprod <- dbeta(n_nonprod, 442, 420)

# Monte Carlo approximation of a ratio, where we simulate
# from the posterior distribution
simulations <- 10^6
theta_prod_simulation <- rbeta(simulations, 354, 659)
theta_nonprod_simulation <- rbeta(simulations, 442, 420)
hist(theta_nonprod_simulation/theta_prod_simulation)

# Think about how to update the posterior predictive density
# via a Monte Carlo simulation

# update the posterior distribution using Monte Carlo and compare to the real posterior



sum_x <- 1
n <- 30
# prior parameters
a <- 0.05
b <- 1
# posterior parameters
an <- a + sum_x
bn <- b + n - sum_x

theta <- rbeta(10, an, bn)

log.likelihood <- function(data, theta){
  sum(dbinom(x = data, size = 1, prob = theta, log = TRUE))
}

mean(log.likelihood(1, theta))








likelihood <- function(n, new_data, theta) {
  return(dbeta(theta, new_data + 1, n, new_data - 1))
}

# Compute the posterior risk given c.
# S is the number of random draws.
posterior_predictive <- function(theta, new_data, a_prior, b_prior, n, s = 30000) {
  # Randow draws from beta distribution.
  a_post <- a_prior + new_data
  b_post <- b_prior + n - new_data
  theta <- rbeta(s, a_post, b_post)
  loss <- apply(as.matrix(theta), 1, likelihood)
  # average values from the loss function
  mean(loss)
}


posterior_predictive(theta = 0,
                     new_data = 1, 
                     a_prior = 1,
                     b_prior = 1,
                     n = 30,
                     s = 10)

new_data <- 1
n <- 30
post_risk <- apply(as.matrix(new_data), 1, posterior_predictive, 
                   a_prior=1, b_prior=1, n=30)
head(post_risk)









library(likelihoodExplore)

latitude <- c(36.077916, 36.078032, 36.078129, 36.078048,
              36.077942, 36.089612, 36.077789, 36.077563)

longitude <- c(-79.009266, -79.009180,  -79.009094, -79.008891,
               -79.008962, -79.035760, -79.008917, -79.009281)

data <- data.frame(latitude, longitude)

hist(latitude)

theta_0 <- c(36.059568, -79.034454)
sigma_0 <- c(0.2, 0.2)
sigma <- c(0.002, 0.002)

# latitude only
mean(latitude)
median(latitude)

values <- seq(36.06,36.095, length.out=10)


plot(values, prior(values))

# prior distribution
prior <- function(x, theta_0 = 36.059568, sigma_0 = 0.2){
  return(dcauchy(theta_0, sigma_0))
}

# loglikelihood function
log_like <- function(x, theta){
  return(likcauchy(x, location = theta))
}


log_like <- likcauchy(x = rcauchy(n=10), location=prior(36, 0.2), scale=0.002)
(likelihood <- exp(log_like))
