module Censored

using PyPlot, Distributions
draw_now() = (pause(0.001); get_current_fig_manager()[:window][:raise_]())

rand_TGamma(a,b,c) = (D=Gamma(a,1/b); quantile(D, rand(Uniform(cdf(D,c),1))))

# c = 2
# figure(1,figsize=(10,3)); clf(); hold(true)
# x = [rand_TGamma(1,1,c)::Float64 for i = 1:10^4]
# plt.hist(x,linspace(c,10,100))
# draw_now()
# figure(2,figsize=(10,3)); clf(); hold(true)
# y = rand(Gamma(1,1),10^5)
# y = y[y.>c]
# plt.hist(y,linspace(c,10,100))
# draw_now()

# Parameters
N = 10^3
a,b = 1.0,1.0
r = 2.0

if false # simulate data
    n = 12
    theta_0 = 0.5
    c = rand(Gamma(r,1/theta_0),n)
    z_0 = rand(Gamma(r,1/theta_0),n)
    x = copy(z_0)
    x[x.>c] = -1
    # println([c z_0 x])
    println(c)
    println(x)
end
if false
    c = [1.2015744987792054,4.152572288816593,3.337309533965976,3.80711184842511,4.151836416309097,9.307928627062166,4.999982265878177,1.6765141383415572,1.6940473055899201,1.3932604420638428,5.562309148874335,0.5513304453715119]
    x = [-1.0,3.4347183694198273,2.905244274524769,1.4073234613687804,3.2035564333750206,1.8176230158987805,4.582886741794333,-1.0,-1.0,-1.0,2.8262076385924835,-1.0]
    n = length(x)
    for i = 1:n
        if x[i]==-1
            @printf("%.1f+, ",c[i])
        else
            @printf("%.1f, ", x[i])
        end 
    end
    println()
end
c = [NaN, NaN, 1.2, NaN, NaN, NaN, NaN, 1.7, 2.0, 1.4, NaN, 0.6]
x = [3.4, 2.9, -1.0, 1.4, 3.2, 1.8, 4.6, -1.0, -1.0, -1.0, 2.8, -1.0]

# Initialize
n = length(x)
theta = 1.0
C = find(x.==-1)
z = copy(x)
z[C] = c[C]+1


# Iterate
theta_r = zeros(N)
z_r = zeros(n,N)
for i = 1:N
    # Sample from full conditionals
    theta = rand(Gamma(a + n*r, 1/(b + sum(z))))
    for j in C
        z[j] = rand_TGamma(r,theta,c[j])
    end
    # Record values
    theta_r[i] = theta
    z_r[:,i] = copy(z)
end

# credible interval
theta_sort = sort(theta_r)
lower,upper = theta_sort[int(floor(0.025*N))],theta_sort[int(ceil(0.975*N))]


figure(1,figsize=(10,3)); clf(); hold(true)
subplots_adjust(bottom = 0.2)
plot(theta_r, "k.", markersize=3)
ylim(0,ylim()[2])
xlabel("iteration \$k\$",fontsize=14)
ylabel("\$\\theta\$",fontsize=16)
draw_now()
savefig("censored-theta_trace.png",dpi=120)

z9 = vec(z_r[9,:])

figure(2,figsize=(10,3)); clf(); hold(true)
subplots_adjust(bottom = 0.2)
plot(z9, "k.", markersize=3)
ylim(0,ylim()[2])
xlabel("iteration \$k\$",fontsize=14)
ylabel("\$z_3\$",fontsize=16)
draw_now()
savefig("censored-z_trace.png",dpi=120)

figure(3,figsize=(5,4)); clf(); hold(true)
subplots_adjust(bottom = 0.2)
subplots_adjust(left = 0.2)
edges,counts = hist(theta_r, 30)
bar(edges[1:end-1],counts./(N*diff(edges)),diff(edges))
top = ylim()[2]
plot([lower,lower],[0,top], "m-", linewidth=2)
plot([upper,upper],[0,top], "m-", linewidth=2)
# ylim(0.75,0.85)
xlim(0,xlim()[2])
xlabel("\$\\theta\$  (rate for lifetime distn)",fontsize=16)
ylabel("density",fontsize=14)
draw_now()
savefig("censored-theta_density.png",dpi=120)

figure(4,figsize=(5,4)); clf(); hold(true)
subplots_adjust(bottom = 0.2)
subplots_adjust(left = 0.2)
edges,counts = hist(z9, 30)
bar(edges[1:end-1],counts./(N*diff(edges)),diff(edges))
# ylim(0.75,0.85)
xlim(0,xlim()[2])
xlabel("\$z_9\$  (lifetime of patient 9)",fontsize=16)
ylabel("density",fontsize=14)
draw_now()
savefig("censored-z_density.png",dpi=120)

theta_means = cumsum(theta_r)./[1:N]

figure(5,figsize=(10,3)); clf(); hold(true)
subplots_adjust(bottom = 0.2)
# subplots_adjust(left = 0.2)
plot(theta_means, "b")
# ylim(0.75,0.85)
xlabel("iteration \$k\$",fontsize=14)
ylabel("approx of \$E(\\theta | data)\$",fontsize=16)
draw_now()
savefig("censored-theta_means.png",dpi=120)










end
