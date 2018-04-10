
---
title: "Module 10: Linear Regression"
author: "Rebecca C. Steorts"
output: 
     beamer_presentation:
      includes: 
          in_header: custom2.tex
font-size: 8px
---


Agenda
===
- Oxygen uptake example
- Linear regression
- Multiple Linear Regression
- Ordinary Least Squares
- An application to swimmers

Oxygen uptake experiment
===

Exercise is hypotheized to relate to $O_2$ uptake

What type of exercise is the most beneficial?

Experimental design: 12 male volunteers.
\begin{enumerate}
\item $O_2$ uptake measured at the beginning of the study.
\item 6 men take part in a randomized aerobics program
\item 6 remaining men do a running program
\item $O_2$ uptake measured at end of study
\end{enumerate}

Data
===

```r
# running is 0, 1 is aerobic
x1<-c(0,0,0,0,0,0,1,1,1,1,1,1)
# age
x2<-c(23,22,22,25,27,20,31,23,27,28,22,24)
# change in maximal oxygen uptake
y<-c(-0.87,-10.74,-3.27,-1.97,7.50,
     -7.25,17.05,4.96,10.40,11.05,0.26,2.51)
```

Exploratory Data Analysis
===
![](10-linear-regression_files/figure-beamer/unnamed-chunk-2-1.pdf)<!-- --> 

Data analysis
===

$\by$ = change in oxygen uptake

$x_1$ = exercise indicator (0 for running, 1 for aerobic)

$x_2$ = age

How can we estimate $p(\by \mid x_1, x_2)?$

Linear regression
===
Assume that smoothness is a function of age.

For each group,

$$\by = \beta_o + \beta_1 x_2 + \bm{\epsilon}$$

Linearity means linear in the parameters ($\beta$'s). 

We could also try the model

$$\by = \beta_o + \beta_1 x_2 +  \beta_2 x_2^2 + \beta_3 x_2^3 + \bm{\epsilon}$$

which is also a linear regression model. 

Notation 
===
- $X_{n\times p}$: regression features or covariates (design matrix)
- $\bx_i$: $i$th row vector of the regression covariates
- $\by_{n\times 1}$: response variable (vector)
- $\bbeta_{p \times 1}$: vector of regression coefficients 

Goal: Estimation of $p(\by \mid X).$

Dimensions: $\by_i - \bbeta^T x_i = (1\times 1) - (1\times p)(p \times 1) = (1\times 1).$

Notation (continued)
===
$$\bm{X}_{n \times p} = 
\left( \begin{array}{cccc}
x_{11} & x_{12} & \ldots&  x_{1p}\\
x_{21} & x_{22} & \ldots& x_{2p} \\
x_{i1} & x_{i2} & \ldots& x_{ip} \\
\vdots & \vdots & \ddots & \vdots \\
x_{n1} & x_{n2} &\ldots& x_{np}
\end{array} \right).
$$

- A column of x represents a particular covariate we might be interested in, such as age of a person. 

- Denote $x_i$ as the ith \textcolor{red}{row vector} of the $X_{n \times p}$ matrix. 

\[  x_{i}= \left( \begin{array}{c}
x_{i1}\\
\textcolor{red}{x_{i2}}\\
\vdots\\
x_{ip}
\end{array} \right) \]

Notation (continued)
===
\[  \bbeta= \left( \begin{array}{c}
\beta_1\\
\beta_2\\
\vdots\\
\beta_p
\end{array} \right) \]

\[  \by= \left( \begin{array}{c}
y_1\\
y_2\\
\vdots\\
y_n
\end{array} \right) \]

$$\by_{n \times 1} = 
X_{n \times p} \bbeta_{p \times 1} + \bm{\epsilon}_{n \times 1}$$





Regression models
===
How does an outcome $\bY$ vary as a function of the covariates which we represent as $X_{n\times p}$ matrix?


- Can we predict $\bY$ as a function of each row in the matrix $X_{n\times p}$ denoted by $\bx_i.$
- Which $\bx_i$'s have an effect?

Such a question can be assessed via a linear regression model $p(\by \mid X).$


Multiple linear regression
===
Consider the following: 

$$\bY_i = \beta_1 \bx_{i1} + \beta_2 \bx_{i2} + \beta_3 \bx_{i3} + 
\beta_4 \bx_{i4} + \bm{\epsilon}_i$$

where
\begin{align}
x_{i1} &= 1 \; \text{for subject} \; i \\
x_{i2} &= 0 \; \text{for running}; \text{1 for aerobics}  \\
x_{i3} &= \text{age of subject i}\\
x_{i4} &= x_{i2} \times x_{i3} 
\end{align}

Under this model,
$$E[\bY \mid \bm{x}] = \beta_1 + \beta_3 \times age \; \text{if} \; x_2=0$$
$$E[\bY \mid \bm{x}] = (\beta_1 + \beta_2) + (\beta_3 + \beta_4)\times age \; \text{if} \; x_2=1 $$



Least squares regression lines 
===
![](10-linear-regression_files/figure-beamer/unnamed-chunk-3-1.pdf)<!-- --> 

Multivariate Setup 
===
Let's assume that we have data points $(\bx_i,\by_i)$ available for all  $i=1,\ldots,n.$

- $y$ is the response variable
\[  \by= \left( \begin{array}{c}
y_1\\
y_2\\
\vdots\\
y_n
\end{array} \right)_{n \times 1} \]

- $\bx_{i}$ is the $i$th row of the design matrix $X_{n \times p}.$

Consider the regression coefficients

\[  \bbeta = \left( \begin{array}{c}
\beta_{1}\\
\beta_{2}\\
\vdots\\
\beta_{p}
\end{array} \right)_{p \times 1} \]

Normal Regression Model
===
The Normal regression model specifies that

- $E[Y\mid x]$ is linear and
- the sampling variability around the mean is independently and identically (iid) drawn from a normal distribution

\begin{align}
Y_i &= \beta^T x_i + \bm{\epsilon}_i\\
\epsilon_1,\ldots,\epsilon_n &\stackrel{iid}{\sim} Normal(0,\sigma^2)
\end{align}
 
We can specify a simple Bayesian model as the following: 

$$\by \mid X,\bbeta, \sigma^2 \sim MVN( X\bbeta, \sigma^2 I)$$
$$\bbeta \sim MVN(0, \tau^2 I) $$

Normal Regression Model (continued)
===
This specifies the density of the data: 
\begin{align}
&p(y_1,\ldots,y_n \mid x_1,\ldots x_n, \bbeta, \sigma^2) \\
&= \prod_{i=1}^n p(\by_i \mid \bx_i, \bbeta, \sigma^2) \\
&(2\pi \sigma^2 )^{-n/2} \exp\{
\frac{-1}{2\sigma^2} \sum_{i=1}^n (\by_i - \bbeta^T \bx_i)^2
\}\\
&= (2\pi \sigma^2 )^{-n/2} \exp\{ (\by - X\bbeta)^T\textcolor{red}{(\sigma^2)^{-1} I}(\by - X\bbeta)\}
\end{align}


Ordinary Least Squares
===
We estimate the coefficients $\hbeta \in \R^p$ by least squares:
$$\hbeta = \argmin_{\bbeta \in \R^p} \|\by-X\hbeta\|_2^2$$
This gives
$$\hbeta = (X^T X)^{-1} X^T \by$$
(Check: does this match the expressions for univariate regression,
without and with an intercept?)

\bigskip
The fitted values are
$$\hy = X\hbeta = X(X^T X)^{-1} X^T \by$$
This is a linear function of $\by$, $\hy = H\by$, where
$H=X(X^T X)^{-1} X^T$ is sometimes called the hat matrix

Ordinary Least squares estimation
===
Let SSR denote sum of squared residuals. 
$$ \min_\beta SSR(\hbeta) = \min_\beta  \|\by-X\hbeta\|_2^2$$
Then 
\begin{align}
 \frac{\partial SSR(\hbeta)}{\partial d\hbeta} &= 
\frac{\partial (\by-X\hbeta)^T(\by-X\hbeta)}{\partial d\hbeta} \\
&= \frac{\partial \by^T\by - 2\hbeta^TX^T\by + \hbeta^T(X^TX)\hbeta}{\partial d\hbeta}\\
& = -  2X^T\by + 2X^TX\hbeta
\end{align}

This implies $-X^T\by + X^TX\hbeta= 0 \implies \hbeta  = (X^TX)^{-1}X^T\by.$
\vskip 1em
Called the ordinary least squares estimator. When is it unique?

Ordinary Least squares estimation
===
$$\hbeta  = (X^TX)^{-1}X^T\bY. $$
\vskip 1em
$$E(\hbeta ) = E[(X^TX)^{-1}X^T\bY]= 
(X^TX)^{-1}X^T E[\bY] = (X^TX)^{-1}X^TX
\bbeta.$$

\vskip 1em
\begin{align}
\Var(\hbeta) &= \Var\{ (X^TX)^{-1}X^T\bY\}\\
 &=
(X^TX)^{-1}X^T \sigma^2 I_n X (X^TX)^{-1}\\
& = \sigma^2  (X^TX)^{-1}
\end{align}

$$\hbeta \sim MVN(\bbeta, \sigma^2  (X^TX)^{-1}).$$

Recall data set up
===
\footnotesize

```r
# running is 0, 1 is aerobic
x1<-c(0,0,0,0,0,0,1,1,1,1,1,1)
# age
x2<-c(23,22,22,25,27,20,31,23,27,28,22,24)
# change in maximal oxygen uptake
y<-c(-0.87,-10.74,-3.27,-1.97,7.50,
     -7.25,17.05,4.96,10.40,11.05,0.26,2.51)
```
Recall data set up
===
\footnotesize

```r
(x3 <- x2) #age
```

```
##  [1] 23 22 22 25 27 20 31 23 27 28 22 24
```

```r
(x2 <- x1) #aerobic versus running 
```

```
##  [1] 0 0 0 0 0 0 1 1 1 1 1 1
```

```r
(x1<- seq(1:length(x2))) #index of person
```

```
##  [1]  1  2  3  4  5  6  7  8  9 10 11 12
```

```r
(x4 <- x2*x3)
```

```
##  [1]  0  0  0  0  0  0 31 23 27 28 22 24
```

Recall data set up
===
\footnotesize

```r
(X <- cbind(x1,x2,x3,x4))
```

```
##       x1 x2 x3 x4
##  [1,]  1  0 23  0
##  [2,]  2  0 22  0
##  [3,]  3  0 22  0
##  [4,]  4  0 25  0
##  [5,]  5  0 27  0
##  [6,]  6  0 20  0
##  [7,]  7  1 31 31
##  [8,]  8  1 23 23
##  [9,]  9  1 27 27
## [10,] 10  1 28 28
## [11,] 11  1 22 22
## [12,] 12  1 24 24
```

OLS estimation in R
===
\footnotesize

```r
## using the lm function
fit.ols<-lm(y~ X[,2] + X[,3] +X[,4])
summary(fit.ols)$coef
```

```
##                Estimate Std. Error    t value    Pr(>|t|)
## (Intercept) -51.2939459 12.2522126 -4.1865047 0.003052321
## X[, 2]       13.1070904 15.7619762  0.8315639 0.429775106
## X[, 3]        2.0947027  0.5263585  3.9796120 0.004063901
## X[, 4]       -0.3182438  0.6498086 -0.4897500 0.637457484
```


Multivariate inference for regression models
===
\begin{align}
\bm{y} &\mid \bbeta \sim MVN(X \bbeta, \sigma^2 I)\\
\bbeta &\sim MVN(\bbeta_0, \Sigma_0)
\end{align}
The posterior can be shown to be 
$$\bbeta \mid \bm{y}, X \sim MVN(\bbeta_n, \Sigma_n)$$

where

$$\bbeta_n = E[\bbeta\ \mid \bm{y}, \bX, \sigma^2] = (\Sigma_o^{-1} + (X^TX)^{-1}/\sigma^2)^{-1}
(\Sigma_o^{-1}\bbeta_0 + \bX^T\bm{y}/\sigma^2)$$

$$\Sigma_n = \text{Var}[\bbeta \mid \bm{y}, X, \sigma^2] = (\Sigma_o^{-1} + (X^TX)^{-1}/\sigma^2)^{-1}$$

Multivariate inference for regression models
===
The posterior can be shown to be 
$$\bbeta \mid \bm{y}, X \sim MVN(\bbeta_n, \Sigma_n)$$

where

$$\bbeta_n = E[\bbeta\ \mid \bm{y}, \bX, \sigma^2] = (\Sigma_o^{-1} + (X^TX)^{-1}/\sigma^2)^{-1}
(\Sigma_o^{-1}\bbeta_0 + X^T\bm{y}/\sigma^2)$$

$$\Sigma_n = \text{Var}[\bbeta \mid \bm{y}, \bX, \sigma^2] = (\Sigma_o^{-1} + (X^TX)^{-1}/\sigma^2)^{-1}$$

Remark: If $\Sigma_o{-1} << (X^TX)^{-1}$ then $\bbeta_n \approx \hat{\bbeta}_{ols}$

If $\Sigma_o{-1} >> (X^TX)^{-1}$ then $\bbeta_n \approx \bbeta_{0}$

Posterior inference applied to Oxygen uptake
===
To continue the rest of the oxygen uptake example, please refer to 9.2 in Hoff
(commentary and code). Pages 157 -- 159 in Hoff.


Linear Regression Applied to Swimming
===
- We will consider Exercise 9.1 in Hoff very closely to illustrate linear regression. 
- The data set we consider contains times (in seconds) of four high school swimmers swimming 50 yards. 
- There are 6 times for each student, taken every two weeks. 
- Each row corresponds to a swimmer and a higher column index indicates a later date. 

Data set
===


```r
read.table("https://www.stat.washington.edu/~pdhoff/Book/Data/hwdata/swim.dat",header=FALSE)
```

```
##     V1   V2   V3   V4   V5   V6
## 1 23.1 23.2 22.9 22.9 22.8 22.7
## 2 23.2 23.1 23.4 23.5 23.5 23.4
## 3 22.7 22.6 22.8 22.8 22.9 22.8
## 4 23.7 23.6 23.7 23.5 23.5 23.4
```

Full conditionals (Task 1)
===
We will fit a separate linear regression model for each swimmer, with swimming time as the response and week as the explanatory variable. Let $Y_{i}\in \mathbbm{R}^{6}$ be the 6 recorded times for swimmer $i.$ Let
\[X_i =
\begin{bmatrix}
    1 & 1  \\
    1 & 3 \\ 
    ... \\
    1 & 9\\
    1 & 11
\end{bmatrix}
\] be the design matrix for swimmer $i.$ Then we use the following linear regression model: 
\begin{align*}
    Y_i &\sim \mathcal{N}_6\left(X\beta_i, \tau_i^{-1}\mathcal{I}_6\right) \\
    \beta_i &\sim \mathcal{N}_2\left(\beta_0, \Sigma_0\right) \\
    \tau_i &\sim \text{Gamma}(a,b).
\end{align*}
Derive full conditionals for $\beta_i$ and $\tau_i.$ 

Solution (Task 1)
===
The conditional posterior for $\beta_i$ is multivariate normal with 
\begin{align*}
    \mathbbm{V}[\beta_i \, | \, Y_i, X_i, \textcolor{red}{\tau_i} ] &= (\Sigma_0^{-1} + \tau X_i^{T}X_i)^{-1}\\ 
    \mathbbm{E}[\beta_i \, | \, Y_i, X_i, \textcolor{red}{\tau_i} ] &= 
    (\Sigma_0^{-1} + \textcolor{red}{\tau_i} X_i^{T}X_i)^{-1} (\Sigma_0^{-1}\beta_0 + \textcolor{red}{\tau_i} X_i^{T}Y_i).
\end{align*} while
\begin{align*}
    \tau_i \, | \, Y_i, X_i, \beta &\sim \text{Gamma}\left(a + 3\, , \, b + \frac{(Y_i - X_i\beta_i)^{T}(Y_i - X_i\beta_i)}{2} \right).
\end{align*}

These can be found in in Hoff in section 9.2.1.

Task 2
===
Complete the prior specification by choosing $a,b,\beta_0,$ and $\Sigma_0.$ Let your choices be informed by the fact that times for this age group tend to be between 22 and 24 seconds. 

Solution (Task 2)
===
Choose $a=b=0.1$ so as to be somewhat uninformative. 

Choose $\beta_0 = [23\,\,\, 0]^{T}$ with 
\[\Sigma_0 =
\begin{bmatrix}
    5 & 0  \\
    0 & 2 
\end{bmatrix}.
\] This centers the intercept at 23 (the middle of the given range) and the slope at 0 (so we are assuming no increase) but we choose the variance to be a bit large to err on the side of being less informative.

Gibbs sampler (Task 3)
===
Code a Gibbs sampler to fit each of the models. For each swimmer $i,$ obtain draws from the posterior predictive distribution for $y_i^{*},$ the time of swimmer $i$ if they were to swim two weeks from the last recorded time.


 


Posterior Prediction (Task 4)
===
The coach has to decide which swimmer should compete in a meet two weeks from the last recorded time. Using the posterior predictive distributions, compute $\text{Pr}\left\{y_i^{*}=\text{max}\left(y_1^{*},y_2^{*},y_3^{*},y_4^{*}\right)\right\}$ for each swimmer $i$ and use these probabilities to make a recommendation to the coach. 

- This is left as an exercise. 









