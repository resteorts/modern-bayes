setwd("/Users/rebeccasteorts/")
# video that goes with this by Ben Lambert that illustrates the model 
# https://www.youtube.com/watch?v=YZZSYIx1-mw
# generate fake data
N<-100
Y<- rnorm(N,1.6,0.2)
hist(Y)

# write stan code in first_model.stan
# now compile the model

library(rstan)
model <- stan_model('first_model.stan')

# pass data to stan and run the model
options(mc.cores=4)
fit <- sampling(model, list(N=N, Y=Y, iter=200, chains=4))

# diagnose
print(fit)

# extract and graph

params <- extract(fit)
hist(params$mu)
hist(params$sigma)

# automatically does diag
library(shinystan)
launch_shinystan(fit)


