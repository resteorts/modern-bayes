#####
##example 5.9 in notes
## initialing values for normal-normal example and setting seed
# MH algorithm for one-sample normal problem with 
# known variance

s2<-1 
t2<-10 ; mu<-5

set.seed(1)
n<-5
y<-round(rnorm(n,10,1),2)

mu.n<-( mean(y)*n/s2 + mu/t2 )/( n/s2+1/t2) 
t2.n<-1/(n/s2+1/t2)



####metropolis part####
s2<-1 ; t2<-10 ; mu<-5 
y<-c(9.37, 10.18, 9.16, 11.60, 10.33)
##S = total num of simulations
theta<-0 ; delta<-2 ; S<-10000 ; THETA<-NULL ; set.seed(1)

for(s in 1:S)
{

  theta.star<-rnorm(1,theta,sqrt(delta))

  log.r<-( sum(dnorm(y,theta.star,sqrt(s2),log=TRUE)) +
               dnorm(theta.star,mu,sqrt(t2),log=TRUE) )  -
         ( sum(dnorm(y,theta,sqrt(s2),log=TRUE)) +
               dnorm(theta,mu,sqrt(t2),log=TRUE) ) 

  if(log(runif(1))<log.r) { theta<-theta.star }

  THETA<-c(THETA,theta)

}
#####

pdf("metropolis_normal.pdf",family="Times",height=3.5,width=7)
par(mar=c(3,3,1,1),mgp=c(1.75,.75,0))
par(mfrow=c(1,2))

skeep<-seq(10,S,by=10)
plot(skeep,THETA[skeep],type="l",xlab="iteration",ylab=expression(theta))

hist(THETA[-(1:50)],prob=TRUE,main="",xlab=expression(theta),ylab="density")
th<-seq(min(THETA),max(THETA),length=100)
lines(th,dnorm(th,mu.n,sqrt(t2.n)) )
dev.off()


###example 5.10 -- sparrow Poisson regression
yX.sparrow<-dget("http://www.stat.washington.edu/~hoff/Book/Data/data/yX.sparrow")

### sample from the multivariate normal distribution
rmvnorm<-function(n,mu,Sigma)
{
  p<-length(mu)
  res<-matrix(0,nrow=n,ncol=p)
  if( n>0 & p>0 )
  {
    E<-matrix(rnorm(n*p),n,p)
    res<-t(  t(E%*%chol(Sigma)) +c(mu))
  }
  res
}


y<- yX.sparrow[,1]; X<- yX.sparrow[,-1]
n<-length(y) ; p<-dim(X)[2]

pmn.beta<-rep(0,p)
psd.beta<-rep(10,p)

var.prop<- var(log(y+1/2))*solve( t(X)%*%X )
beta<-rep(0,p)
S<-10000
BETA<-matrix(0,nrow=S,ncol=p)
ac<-0
set.seed(1)

for(s in 1:S) {

#propose a new beta

beta.p<- t(rmvnorm(1, beta, var.prop ))

lhr<- sum(dpois(y,exp(X%*%beta.p),log=T)) -
      sum(dpois(y,exp(X%*%beta),log=T)) +
      sum(dnorm(beta.p,pmn.beta,psd.beta,log=T)) -
      sum(dnorm(beta,pmn.beta,psd.beta,log=T))

if( log(runif(1))< lhr ) { beta<-beta.p ; ac<-ac+1 }

BETA[s,]<-beta
                    }
cat(ac/S,"\n")

#######

library(coda)
apply(BETA,2,effectiveSize)



####
pdf("sparrow_plot1.pdf",family="Times",height=1.75,width=5)
par(mar=c(2.75,2.75,.5,.5),mgp=c(1.7,.7,0))
par(mfrow=c(1,3))
blabs<-c(expression(beta[1]),expression(beta[2]),expression(beta[3]))
thin<-c(1,(1:1000)*(S/1000))
j<-3
plot(thin,BETA[thin,j],type="l",xlab="iteration",ylab=blabs[j])
abline(h=mean(BETA[,j]) )

acf(BETA[,j],ci.col="gray",xlab="lag")
acf(BETA[thin,j],xlab="lag/10",ci.col="gray")
dev.off()
####


####
pdf("fig10_6.pdf",family="Times",height=1.75,width=5)
par(mar=c(2.75,2.75,.5,.5),mgp=c(1.7,.7,0))
par(mfrow=c(1,3))

plot(beta2,PB2*length(beta2)/(max(beta2)-min(beta2)) ,type="l",xlab=expression(beta[2]),ylab=expression(paste(italic("p("),beta[2],"|",italic("y)"),sep="") ) ,lwd=2,lty=2,col="gray")
lines(density(BETA[,2],adj=2),lwd=2)

plot(beta3,PB3*length(beta3)/(max(beta3)-min(beta3)),type="l",xlab=expression(beta[3]),ylab=expression(paste(italic("p("),beta[3],"|",italic("y)"),sep="") ),lwd=2,col="gray",lty=2)
lines(density(BETA[,3],adj=2),lwd=2)

Xs<-cbind(rep(1,6),1:6,(1:6)^2) 
eXB.post<- exp(t(Xs%*%t(BETA )) )
qE<-apply( eXB.post,2,quantile,probs=c(.025,.5,.975))

plot( c(1,6),range(c(0,qE)),type="n",xlab="age",
   ylab="number of offspring")
lines( qE[1,],col="black",lwd=1)
lines( qE[2,],col="black",lwd=2)
lines( qE[3,],col="black",lwd=1)


dev.off()
####
