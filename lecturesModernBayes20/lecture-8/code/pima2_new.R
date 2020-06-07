library(MASS) 
library(mvtnorm)
library(MCMCpack)
data(Pima.tr)
Y0<-Pima.tr[,2:5]
Y<-Y0
n<-dim(Y)[1]
p<-dim(Y)[2]

set.seed(1)
O<-matrix(rbinom(n*p,1,.9),n,p)
Y[O==0]<-NA
#####

#####
pdf("fig7_3.pdf",family="Times", height=6,width=6)
par(mar=c(1,1,.5,.5)*1.75,mfrow=c(p,p),mgp=c(1.75,.75,0))
for(j1 in 1:p) {
for(j2 in 1:p) {
 if(j1==j2){hist(Y[,j1],main="");mtext(colnames(Y)[j1],side=3,line=-.1,cex=.7)}
  if(j1!=j2) { plot(Y[,j1],Y[,j2],xlab="",ylab="",pch=16,cex=.7)} 
                }}
dev.off()
#####

############################


### prior parameters
p<-dim(Y)[2]
mu0<-c(120,64,26,26)
sd0<-(mu0/2)
L0<-matrix(.1,p,p) ; diag(L0)<-1 ; L0<-L0*outer(sd0,sd0)
nu0<-p+2 ; S0<-L0
###

### starting values
Sigma<-S0
Y.full<-Y
for(j in 1:p)
{
  Y.full[is.na(Y.full[,j]),j]<-mean(Y.full[,j],na.rm=TRUE)
}
###


### Gibbs sampler
THETA<-SIGMA<-Y.MISS<-NULL
set.seed(1)

#d45<-dget("data.f7_4.f7_5")
#SIGMA<-d45$SIGMA ; THETA<-d45$THETA; Y.MISS<-d45$Y.MISS

#if(!exists("d45")) {
	
for(s in 1:100) {

  ###update theta
  ybar <- apply(Y.full,2,mean)
  Ln <- solve(solve(L0) + n*solve(Sigma))
  mun <- Ln %*% (solve(L0) %*% mu0 + n*solve(Sigma) %*% ybar)
  theta <- rmvnorm(1, mun, Ln)
  ###
  
  ###update Sigma
  Sn <- S0 + (t(Y.full) - c(theta)) %*% t(t(Y.full)-c(theta))
  Sigma <- solve(rwish(nu0 + n, solve(Sn)))
 # Sigma<-rinvwish(1,nu0+n,solve(Sn))
 # Sigma<-solve( n=(1, nu=nu0+n, Psi=solve(Sn)) )
  ###
  
  ###update missing data
  for(i in 1:n) { 
    b <- ( O[i,]==0 )
    if (sum(b) > 0){
      a <- ( O[i,]==1 )
      iSa<- solve(Sigma[a,a])
      beta.j <- Sigma[b,a]%*%iSa
      s2.j   <- Sigma[b,b] - Sigma[b,a]%*%iSa%*%Sigma[a,b]
      theta.j<- theta[b] + beta.j%*%(t(Y.full[i,a])-theta[a])
      Y.full[i,b] <- rmvnorm(1,theta.j,s2.j )
    }
  }
  
  ### save results
  THETA<-rbind(THETA,theta)
  SIGMA<-rbind(SIGMA, c(Sigma))
  Y.MISS<-rbind(Y.MISS, Y.full[O==0] )

}
#}
#############

apply(THETA,2,mean)

COR <- array( dim=c(p,p,1000) )
for(s in 1:1000)
{
  Sig<-matrix( SIGMA[s,] ,nrow=p,ncol=p)
  COR[,,s] <- Sig/sqrt( outer( diag(Sig),diag(Sig) ) )
}


apply(COR,c(1,2),mean)

