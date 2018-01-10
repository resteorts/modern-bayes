Teaching Bayes: Markdown
================================================
author: Rebecca C. Steorts
date: June 9, 2016

- In class, we saw the Beta-Bernoulli model. 
- We will now use this to solve a very real problem! Suppose I wish to determine whether the probability that a worker will fake an illness is truly 1\%. Your task is to assist me!
- Let's outline these our tasks and then solve them.
============================================

Simulation
- {Simulate some data using the \textsf{rbinom} function of size $n = 100$ and probability equal to 1\%. Remember to \textsf{set.seed(123)} so that you can replicate your results.}
- {Write a function that takes as its inputs that data you simulated (or any data of the same type) and a sequence of $\theta$ values of length 1000 and produces Likelihood values based on the Binomial Likelihood. Plot your sequence and its corresponding Likelihood function.}
- {Write a function that takes as its inputs  prior parameters \textsf{a} and \textsf{b} for the Beta-Bernoulli model and the observed data, and produces the posterior parameters you need for the model. Generate the posterior parameters for a non-informative prior i.e. \textsf{(a,b) = (1,1)} and for an informative case \textsf{(a,b) = (3,1)}}
- {Create two plots, one for the informative and one for the non-informative case to show the posterior distribution and superimpose the prior distributions on each along with the likelihood. What do you see? Remember to turn the y-axis ticks off since superimposing may make the scale non-sense.}
- {Based on the informative case, generate a 95\% credible interval with 1000 posterior draws and a 95\% confidence interval for your parameter of interest, and use \textsf{xtable} to output these. What is the problem?}
- {Based on the data you simulated, do you conclude that the true value higher or lower than 1\%?}



