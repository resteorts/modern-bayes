module PowerLaw

using PyPlot, Distributions
draw_now() = (pause(0.001); get_current_fig_manager()[:window][:raise_]())

# Extract data file for names
if false
    data,header = readdlm("names.csv", ',', header=true)
    names = data[:,1]
    counts = int(data[:,3])
    writedlm("names.dat",counts)
end
# Extract data file for wealth
if false
    data,header = readdlm("forbes.tsv", '\t', header=true)
    # names = data[:,1]
    wealth = [float(w[2:end-2]) for w in data[:,3]]
    # wealth = data[:,3]
    writedlm("wealth.dat",wealth)
end
# Extract data file for nycities
if false
    data,header = readdlm("nycities.tsv", '\t', header=true)
    population = vec(int(data[:,3]))
    # wealth = data[:,3]
    writedlm("nycities.dat",population)
end
# Extract data file for nccities
if true
    # 50 largest cities in North Carolina
    # Source: http://en.wikipedia.org/wiki/List_of_municipalities_in_North_Carolina
    # Date accessed: 2/6/2015
    data,header = readdlm("nccities.tsv", '\t', header=true)
    population = vec(int(data[:,4]))  # 2010 Census
    writedlm("nccities.dat",population)
    
    for i=1:50
        println("$(int(data[i,1]))  &  $(data[i,2])  &  $(population[i]) \\\\")
    end
end

# x = int(readdlm("names.dat"))
# x = float(readdlm("wealth.dat"))
# x = vec(float(readdlm("blackouts.dat")))
x = vec(float(readdlm("nccities.dat")))

if false # use subsample
    n = 10
    sample = randperm(length(x))[1:n]
    x = x[sample]
    # println([names[sample] x])
    # println(x)
end

rand_mono(a,b) = b*rand()^(1/a)
logpdf_Pareto(a,c,x) = log(a) + a*log(c) - (a+1)*log(x)
survival_Pareto(a,c,x) = (c./x).^a

# Initialize
a,c = 1.0,100.0
N = 10^3

# Precompute statistics
n = length(x)
sum_log = sum(log(x))
min_x = minimum(x)

# Gibbs sampling
a_r = zeros(N)
c_r = zeros(N)
for i = 1:N
    a = rand(Gamma(n+1, 1/(sum_log - n*log(c))))
    c = rand_mono(n*a+1, min_x)
    a_r[i] = a
    c_r[i] = c
end

a_mean = mean(a_r)
c_mean = mean(c_r)
println("posterior mean for a = $a_mean")
println("posterior mean for c = $c_mean")

figure(1,figsize=(10,3)); clf(); hold(true)
subplots_adjust(bottom = 0.2)
plot(a_r, "k.", markersize=3)
# ylim(0.75,0.85)
xlabel("iteration \$k\$",fontsize=14)
ylabel("\$\\alpha_k\$",fontsize=16)
draw_now()
savefig("Pareto-a_trace.png",dpi=120)

figure(2,figsize=(10,3)); clf(); hold(true)
subplots_adjust(bottom = 0.2)
plot(c_r, "k.", markersize=3)
# ylim(99.99,100.01)
xlabel("iteration \$k\$",fontsize=14)
ylabel("\$c_k\$",fontsize=16)
draw_now()
savefig("Pareto-c_trace.png",dpi=120)

figure(3,figsize=(5,4)); clf(); hold(true)
subplots_adjust(bottom = 0.2)
subplots_adjust(left = 0.2)
plot(a_r,c_r, "b.", markersize=3)
# ylim(99.99,100.01)
xlabel("\$\\alpha\$  (shape)",fontsize=16)
ylabel("\$c\$  (scale)",fontsize=16)
draw_now()
savefig("Pareto-scatterplot.png",dpi=120)

# compute posterior survival function
n_points = 50
points = logspace(log10(minimum(x)),log10(maximum(x)),n_points)
posterior_survival = zeros(n_points)
for i = 1:N
    posterior_survival += survival_Pareto(a_r[i], c_r[i], points)
end
posterior_survival /= N

figure(4,figsize=(5,4)); clf(); hold(true)
subplots_adjust(bottom = 0.2)
subplots_adjust(left = 0.2)
sx = sort(x)
loglog(sx,linspace(1,1/n,n),"r-", label="empirical", linewidth=2)
# loglog(sx,survival_Pareto(a_mean,c_mean,sx),"r")
loglog(points,posterior_survival,"b", label="posterior", linewidth=2)
xlabel("\$x\$  (population of city)",fontsize=14)
ylabel("\$P\\,(X > x)\$",fontsize=14)
legend(loc="upper right",labelspacing=0.1,fontsize=14) #names,fontsize=fontsize,numpoints=1,ncol=ncol)
draw_now()
savefig("Pareto-survival-function.png",dpi=120)

a_means = cumsum(a_r)./[1:N]

figure(5,figsize=(5,4)); clf(); hold(true)
subplots_adjust(bottom = 0.2)
subplots_adjust(left = 0.2)
plot(a_means, "b")
ylim(0.8,1.1)
# ylim(0.75,0.85)
xlabel("iteration \$k\$",fontsize=14)
ylabel("approx of \$E(\\alpha | data)\$",fontsize=16)
draw_now()
savefig("Pareto-a_means.png",dpi=120)

a_sort = sort(a_r)
lower,upper = a_sort[int(0.05*N)],a_sort[int(0.95*N)]

figure(6,figsize=(5,4)); clf(); hold(true)
subplots_adjust(bottom = 0.2)
subplots_adjust(left = 0.2)
edges,counts = hist(a_r, 50)
bar(edges[1:end-1],counts./(N*diff(edges)),diff(edges))
plot([lower,lower],[0,ylim()[2]], "m-", linewidth=2)
plot([upper,upper],[0,ylim()[2]], "m-", linewidth=2)
# ylim(0.75,0.85)
xlabel("\$\\alpha\$",fontsize=16)
ylabel("density",fontsize=14)
draw_now()
savefig("Pareto-a_density.png",dpi=120)






end

