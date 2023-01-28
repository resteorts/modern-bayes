#playing around with an importance sampling example

latitude <- c(36.077916, 36.078032, 36.078129, 36.078048,
              36.077942, 36.089612, 36.077789, 36.077563)

longitude <- c(79.009266, 79.009180,  79.009094, 79.008891,
               79.008962, 79.035760, 79.008917, 79.009281)

hist(latitude)

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

