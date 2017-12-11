module Mix

using PyPlot, Distributions
draw_now() = (pause(0.001); get_current_fig_manager()[:window][:raise_]())

# Load dataset
data = readdlm("selfreport.dat",' ')
subset = 804:2060  # Use only Krul data
x = convert(Array{Float64,1},data[subset+1,5]) # measured heights
n = length(x)

# Parameters
sigma = 8  # component standard deviation (same as used in height.jl (Dutch heights) from Module 4)
lambda = 1/sigma^2  # component precision
a,b = 1.0,1.0  # Beta parameters
m = 175  # Prior mean for means (175 cm ~ 5 foot 9 inches)
l = 1/15^2 # Prior precision for means (Note: 15 cm ~ 6 inches)

# Initialize
p = 0.5  # mixture weights (Z_i|p ~ Bernoulli(p))
z = int(rand(n).<0.5)  # allocation variables (uniformly random initialization)
mu0 = m
mu1 = m  # means

# Gibbs sampling
N = 10^3
mu0_r = zeros(N)
mu1_r = zeros(N)
p_r = zeros(N)
for i = 1:N
    n1 = sum(z)
    n0 = n - n1

    # update p
    p = rand(Beta(a+n1, b+n0))

    # update mu
    L0 = l + n0*lambda
    L1 = l + n1*lambda
    M0 = (l*m + lambda*sum(x[z.==0]))/L0
    M1 = (l*m + lambda*sum(x[z.==1]))/L1
    mu0 = rand(Normal(M0,1/sqrt(L0)))
    mu1 = rand(Normal(M1,1/sqrt(L1)))

    # update z
    D0 = Normal(mu0,sigma)
    D1 = Normal(mu1,sigma)
    for j = 1:n
        q0 = (1-p)*pdf(D0,x[j])
        q1 = p*pdf(D1,x[j])
        z[j] = int(rand() < q1/(q0+q1))
    end

    # record samples
    mu0_r[i] = mu0
    mu1_r[i] = mu1
    p_r[i] = p
end


figure(1,figsize=(10,3)); clf(); hold(true)
subplots_adjust(bottom = 0.2)
plot(mu0_r, "b.", markersize=3, label="\$\\mu_0\$")
plot(mu1_r, "r.", markersize=3, label="\$\\mu_1\$")
#ylim(0,ylim()[2])
xlabel("iteration",fontsize=14)
ylabel("mean height (cm)",fontsize=14)
legend(numpoints=5,markerscale=1.5,loc="center right",labelspacing=0.0,fontsize=15)
draw_now()
savefig("mix-mu_trace.png",dpi=120)


figure(2,figsize=(10,3)); clf(); hold(true)
subplots_adjust(bottom = 0.2)
plot(p_r, "g.", markersize=3)
#ylim(0,ylim()[2])
xlabel("iteration",fontsize=14)
ylabel("\$\\pi\$",fontsize=16)
ylim(0,1)
draw_now()
savefig("mix-p_trace.png",dpi=120)


# Histograms of measured heights - c1 and c0
figure(3,figsize=(10,3)); clf(); hold(true)
lower,upper = 140,215
edges = [lower:2.5:upper]
edges,c0 = hist(x[z.==0],edges)
edges,c1 = hist(x[z.==1],edges)
bins = midpoints(edges)
plot(midpoints(edges),c0,"b",label="component 0",linewidth=2)
plot(midpoints(edges),c1,"r",label="component 1",linewidth=2)
# title("Heights, c0 and c1")
xlabel("height (cm)",fontsize=14)
ylabel("# of people",fontsize=14)
subplots_adjust(bottom = 0.2)
xticks(lower:5:upper)
xlim(lower,upper)
grid(true)
legend(numpoints=1,loc="upper right",labelspacing=0.1,fontsize=15) #names,fontsize=fontsize,numpoints=1,ncol=ncol)
# tick_params(axis="x",direction="out",top="off")
draw_now()
savefig("mix-histograms_at_last_sample.png",dpi=120)

# Distribution of measured heights - c1 and c0
figure(4,figsize=(10,3)); clf(); hold(true)
lower,upper = 140,215
edges = [lower:2.5:upper]
edges,c0 = hist(x[z.==0],edges)
edges,c1 = hist(x[z.==1],edges)
bins = midpoints(edges)
n1 = sum(z)
n0 = n - n1
c0_density = c0./(n0*diff(edges))
c1_density = c1./(n1*diff(edges))
plot(midpoints(edges),c0_density,"b",label="component 0",linewidth=2)
plot(midpoints(edges),c1_density,"r",label="component 1",linewidth=2)
# title("Heights, c0 and c1")
xlabel("height (cm)",fontsize=14)
ylabel("count density",fontsize=14)
subplots_adjust(bottom = 0.2)
xticks(lower:5:upper)
xlim(lower,upper)
grid(true)
legend(numpoints=1,loc="upper right",labelspacing=0.1,fontsize=15) #names,fontsize=fontsize,numpoints=1,ncol=ncol)
# tick_params(axis="x",direction="out",top="off")
draw_now()
savefig("mix-densities_at_last_sample.png",dpi=120)
# "normalized histogram" --- histogram normalized to a density



end

