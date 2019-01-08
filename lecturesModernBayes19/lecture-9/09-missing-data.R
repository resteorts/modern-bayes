---
title: "Lab 9: Application to Pima Data Set"
author: "Rebecca C. Steorts"
output:
  beamer_presentation:
  includes:
  in_header: custom2.tex
font-size: 8px
---

Application to Pima Indian data set
===

  We first talk about hyper-parameter selection and then implement the Gibbs sampler.

Recall the full model is

$$\bm{Y}_i \mid \btheta, \Sigma \sim MVN(\btheta_i, \Sigma).$$
  $$ \btheta_i \sim MVN(\bm{\mu_0}, \Lambda_0)$$
  $$ \Sigma \sim \text{inverseWishart}(\nu_o, S_o^{-1}).$$

  Hyper-parameter selection
===
  The prior mean of $\bm{\mu_0} =
  (120,64,26,26)^T$ is taken from national averages.

The corresponding prior variances are based primarily on keeping most of the prior mass on values that are above zero.

These prior distributions are likely much more diffuse than more informed prior distributions that could be provided by an expert in this field of study.

The data set
===
  ```{r}
head(Y)
n <- dim(Y)[1]
p <- dim(Y)[2]
```

Prior parameter specification
===
  ```{r}
mu0 <- c(120,64,26,26)
(sd0 <- mu0/2)
(L0 <- matrix(0.1, p,p))
diag(L0) <- 1
L0 <- L0*outer(sd0,sd0)
nu0 <- p + 2
S0 <- L0
```

Starting values
===
  ```{r}
Sigma <- S0
Y.full <- Y
# 1 for observed values
# 0 for NA's
O <- 1*(!is.na(Y))

# replace the NA values with #average of all the observed
# values in column j

for(j in 1:p){
  Y.full[is.na(Y.full[,j]),j]<- mean(Y.full[,j],na.rm=TRUE)
}
```

Gibbs sampler
===
  \footnotesize
```{r}
THETA<-SIGMA<-Y.MISS<-NULL
set.seed(1)
n.iter <- 1000
for(s in 1:n.iter) {
  ## update theta
  ybar <- apply(Y.full,2,mean)
  Ln <- solve(solve(L0) + n*solve(Sigma))
  mun <- Ln %*% (solve(L0) %*% mu0 + n*solve(Sigma) %*% ybar)
  theta <- rmvnorm(1, mun, Ln)

  ## update Sigma
  Sn <- S0 + (t(Y.full) - c(theta)) %*% t(t(Y.full)-c(theta))
  Sigma <- solve(rwish(nu0 + n, solve(Sn)))

  ###update missing data
  for(i in 1:n) {
    b <- (O[i,]==0)
    if (sum(b) > 0){
      a <- ( O[i,]==1 )
      iSa<- solve(Sigma[a,a])
      beta.j <- Sigma[b,a]%*%iSa
      s2.j   <- Sigma[b,b] - Sigma[b,a]%*%iSa%*%Sigma[a,b]
      theta.j<- theta[b] + beta.j%*%(t(Y.full[i,a])-theta[a])
      Y.full[i,b] <- rmvnorm(1,theta.j,s2.j )
    }}
  ## save results
  THETA<-rbind(THETA,theta)
  SIGMA<-rbind(SIGMA, c(Sigma))
  Y.MISS<-rbind(Y.MISS, Y.full[O==0])
}
```



Posterior appx of $E[\theta \mid y]$
  ===
  ```{r}
(theta_mean <- apply(THETA,2,mean))
```

95 percent credible interval
===
  ```{r}
library(knitr)
interval.theta <-  apply(THETA, 2, quantile, c(0.025, 0.975))
kable(data.frame(interval.theta))
```

Posterior appx of $E[\Sigma \mid y]$
  ===
  ```{r}
COR <- array( dim=c(p,p,1000) )
for(s in 1:1000)
{
  Sig<-matrix( SIGMA[s,] ,nrow=p,ncol=p)
  COR[,,s] <- Sig/sqrt( outer( diag(Sig),diag(Sig) ) )
}



apply(COR,c(1,2),mean)
```

95 \% confidence intervals for $E[\Sigma \mid y]$
  ===
  ```{r}
interval.sigma <- apply(COR, c(1,2), quantile,prob=c(.025,.975))
kable(data.frame(interval.sigma))
```

95 percent posterior confidence intervals
===
  ```{r}
library(sbgcop)
colnames(COR)<-rownames(COR)<-colnames(Y)
par(mfcol=c(4,2),mar=c(1,2.75,1,1),mgp=c(1.75,.75,0),oma=c(1.5,0,0,0))
plotci.sA(COR)
REG<-sR.sC(COR)
plotci.sA(REG)
```

95 percent posterior confidence intervals for correlations (left) and regression coefficients derived from the correlation matrix (right). The bottom row of plots, for example, shows that while there is strong evidence that the correlations between bmi and each of the other variables are all positive, the plots on the right-hand side suggest that bmi is nearly conditionally independent of glu and bp given skin.
