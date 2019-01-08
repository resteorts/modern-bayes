# Analyze data from the Pygmalion study using Normal-NormalGamma model
module Pygmalion

using PyPlot, Distributions
draw_now() = (pause(0.001); get_current_fig_manager()[:window][:raise_]())

# treatment group
x = [18, 40, 15, 17, 20, 44, 38]
# control group
y = [-4, 0, -19, 24, 19, 10, 5, 10, 29, 13, -9, -8, 20, -1, 12, 21, -7, 14,
     13, 20, 11, 16, 15, 27, 23, 36, -33, 34, 13, 11, -19, 21, 6, 25, 30,
     22, -28, 15, 26, -1, -2, 43, 23, 22, 25, 16, 10, 29]

m = 0
c = 1
a = 1/2
b = 10^2*a


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

Mx,Cx,Ax,Bx,mx,vx = NormalGamma_posterior(x,m,c,a,b)
My,Cy,Ay,By,my,vy = NormalGamma_posterior(y,m,c,a,b)
sx,sy = sqrt(vx),sqrt(vy)



lower,upper = -52.5,52.5

# Histograms
figure(1,figsize=(10,4)); clf(); hold(true)
edges = lower:5:upper
edges,cx = hist(x,edges)
edges,cy = hist(y,edges)
bins = midpoints(edges)
bar(bins-1.5,cx,1.5,color="r",label="spurters")
bar(bins,cy,1.5,color="b",label="controls")
# title("Change in IQ for treatment and control")
xlabel("Change in IQ score",fontsize=14)
ylabel("# of students",fontsize=14)
subplots_adjust(bottom = 0.2)
xticks(bins)
xlim(minimum(bins),maximum(bins))
ylim(0,10)
grid(true)
legend(loc=6,numpoints=1,labelspacing=0.1,fontsize=15) #names,fontsize=fontsize,numpoints=1,ncol=ncol)
# tick_params(axis="x",direction="out",top="off")
draw_now()
# savefig("pygmalion-histogram.png",dpi=120)


# Scatterplot of prior
N = 500
mu,lambda = NormalGamma_sample(N,m,c,a,b)
figure(2,figsize=(10,5)); clf(); hold(true)
plot(mu,1.0./sqrt(lambda),"go",markersize=3,markeredgecolor="g")
xlabel("\$\\mu\$  (Mean change in IQ score)",fontsize=14)
ylabel("\$\\lambda^{-1/2}\$  (Std.dev. of change)",fontsize=14)
subplots_adjust(bottom = 0.2)
xticks(bins)
xlim(minimum(bins),maximum(bins))
ylim(0,40)
grid(true)
# legend(loc=6,numpoints=1,labelspacing=0.1,fontsize=15,markerscale=2) #names,fontsize=fontsize,numpoints=1,ncol=ncol)
# tick_params(axis="x",direction="out",top="off")
draw_now()
# savefig("pygmalion-prior.png",dpi=120)

# Scatterplots of posterior
N = 250
mu_x,lambda_x = NormalGamma_sample(N,Mx,Cx,Ax,Bx)
mu_y,lambda_y = NormalGamma_sample(N,My,Cy,Ay,By)
figure(3,figsize=(10,5)); clf(); hold(true)
plot(mu_x,1.0./sqrt(lambda_x),"r^",label="spurters",markersize=3,markeredgecolor="r")
plot(mu_y,1.0./sqrt(lambda_y),"bo",label="controls",markersize=3,markeredgecolor="b")
xlabel("\$\\mu\$  (Mean change in IQ score)",fontsize=14)
ylabel("\$\\lambda^{-1/2}\$  (Std.dev. of change)",fontsize=14)
subplots_adjust(bottom = 0.2)
xticks(bins)
xlim(minimum(bins),maximum(bins))
ylim(0,40)
grid(true)
legend(loc=6,numpoints=1,labelspacing=0.1,fontsize=15,markerscale=2) #names,fontsize=fontsize,numpoints=1,ncol=ncol)
# tick_params(axis="x",direction="out",top="off")
draw_now()
# savefig("pygmalion-posteriors.png",dpi=120)


# Compute posterior quantities
N = 10^6
mu_x,lambda_x = NormalGamma_sample(N,Mx,Cx,Ax,Bx)
mu_y,lambda_y = NormalGamma_sample(N,My,Cy,Ay,By)

println("Summary statistics:")
println("n(x) = ",length(x))
println("n(y) = ",length(y))
println("mean(x) = ",mx)
println("mean(y) = ",my)
println("std(x) = ",sx)
println("std(y) = ",sy)
println("posterior_x: M,C,A,B = $Mx, $Cx, $Ax, $Bx")
println("posterior_y: M,C,A,B = $My, $Cy, $Ay, $By")
println()
println("Probability that the Pygmalion group improved more:")
println("P(mu_x > mu_y | data) = ",mean(mu_x.>mu_y))
println()
println("Probability that the standard deviation of the Pygmalion group is higher:")
println("P(sigma_x > sigma_y | data) = ",mean(lambda_x.<lambda_y))
println()




end

