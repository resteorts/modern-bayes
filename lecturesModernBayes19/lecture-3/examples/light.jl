module Newcomb

using PyPlot, Distributions
draw_now() = (pause(0.001); get_current_fig_manager()[:window][:raise_]())

# Simon Newcomb's measurements of the speed of light
# Units: Time (in millionths of seconds, i.e. 10^-6 seconds) required to travel (about) 7442 meters.
# (The currently accepted value would be 24.8238, I think.)
x = convert(Array{Float64,1},readdlm("newcomb.dat",' ')[:])
x = 7442./(x.*100) # convert to speed (x 10^8 meters/second)

c = 299792458 # true value (meters/second)
truth = c/10^8

# prior parameters
m = 3
c = 1
a = 1/2
b = (1e-2)^2*a


function NormalGamma_posterior(x,m,c,a,b)
    mx = mean(x)
    vx = mean((x-mx).^2)
    n = length(x)
    C = c + n
    A = a + n/2
    M = (c*m + n*mx)/C
    B = b + 0.5*n*vx + 0.5*(c*n/C)*(mx-m)^2
    return M,C,A,B,mx,vx
end

function NormalGamma_sample(n,m,c,a,b)
    lambda = rand(Gamma(a,1/b),n)
    mu = rand(Normal(0,1),n)./sqrt(c*lambda) + m
    return (mu,lambda)
end

S = setdiff([1:66],6) # excluding outlier

Mx,Cx,Ax,Bx,mx,vx = NormalGamma_posterior(x,m,c,a,b)
Me,Ce,Ae,Be,me,ve = NormalGamma_posterior(x[S],m,c,a,b)
sx,se = sqrt(vx),sqrt(ve)


lower,upper = range = (2.994,3.008)
points = lower:0.002:upper

figure(4,figsize=(10,5)); clf(); hold(true)
plot(x)
title("Sequence of measurements",fontsize=16)
ylabel("speed (\$\\times 10^8\$ meters/second)",fontsize=14)
xlabel("measurement #",fontsize=14)
draw_now()
savefig("light-sequence.png",dpi=120)


figure(4,figsize=(10,5)); clf(); hold(true)
plt.hist(x,49,range)
title("Histogram (speed of light measurements)",fontsize=16)
ylabel("count",fontsize=14)
xlabel("speed (\$\\times 10^8\$ meters/second)",fontsize=14)
draw_now()
savefig("light-histogram.png",dpi=120)


# Scatterplot of prior
N = 500
mu,lambda = NormalGamma_sample(N,m,c,a,b)
figure(3,figsize=(10,5)); clf(); hold(true)
plot(mu,1.0./sqrt(lambda),"go",markersize=3,markeredgecolor="g")
xlabel("\$\\mu\$  (speed of light)",fontsize=14)
ylabel("\$\\sigma\$  (Std.dev. of measurements)",fontsize=14)
subplots_adjust(bottom = 0.2)
# xticks(points)
# xlim(range)
# ylim(0,?)
grid(true)
# legend(loc=6,numpoints=1,labelspacing=0.1,fontsize=15,markerscale=2) #names,fontsize=fontsize,numpoints=1,ncol=ncol)
draw_now()
savefig("light-prior.png",dpi=120)

# Scatterplots of posterior
N = 250
mu_x,lambda_x = NormalGamma_sample(N,Mx,Cx,Ax,Bx)
mu_e,lambda_e = NormalGamma_sample(N,Me,Ce,Ae,Be)
figure(4,figsize=(10,5)); clf(); hold(true)
plot(mu_x,1.0./sqrt(lambda_x),"r^",label="using all data",markersize=3,markeredgecolor="r")
plot(mu_e,1.0./sqrt(lambda_e),"bo",label="excluding outlier",markersize=3,markeredgecolor="b")
xlabel("\$\\mu\$  (speed of light)",fontsize=14)
ylabel("\$\\sigma\$  (Std.dev. of measurements)",fontsize=14)
subplots_adjust(bottom = 0.2)
xticks(points)
# xlim(range)
# ylim(0,?)
grid(true)
legend(loc=5,numpoints=1,labelspacing=0.1,fontsize=15,markerscale=2) #names,fontsize=fontsize,numpoints=1,ncol=ncol)
draw_now()
savefig("light-posteriors.png",dpi=120)


# Posterior predictive samples
N = 10^5
mu_e,lambda_e = NormalGamma_sample(N,Me,Ce,Ae,Be)
y = [rand(Normal(mu_e[i],1/sqrt(lambda_e[i])))::Float64 for i = 1:N]
figure(5,figsize=(10,5)); clf(); hold(true)
plt.hist(y,50)
xlabel("\$\\mu\$  (speed of light)",fontsize=14)
ylabel("\$\\sigma\$  (Std.dev. of measurements)",fontsize=14)
subplots_adjust(bottom = 0.2)
xticks(points)
# xlim(range)
# ylim(0,?)
grid(true)
draw_now()
savefig("light-posteriors.png",dpi=120)

# Outlier tail probability
tail_MC = mean(y .>= 3.0061)
println(@sprintf("Outlier tale probability (Monte carlo) = %.8f",tail_MC))

tail = mean([1-cdf(Normal(mu_e[i],1/sqrt(lambda_e[i])),3.0061)::Float64 for i = 1:N])
println(@sprintf("Outlier tale probability = %.8e",tail))







end # module





