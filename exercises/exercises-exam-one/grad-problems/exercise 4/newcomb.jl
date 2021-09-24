
using PyPlot, Distributions
draw_now() = (pause(0.001); get_current_fig_manager()[:window][:raise_]())

# Simon Newcomb's measurements of the speed of light
# Units: Time (in millionths of seconds, i.e. 10^-6 seconds) required to travel (about) 7442 meters.
# (The currently accepted value would be 24.8238, I think.)
x = convert(Array{Float64,1},readdlm("newcomb.dat",' ')[:])
x = 7442./(x.*100) # convert to speed (x 10^8 meters/second)

c = 299792458 # true value (meters/second)
truth = c/10^8

n = length(x)
sigma = std(x)
lambda = 1/sigma^2
println("n = $n")
println("sigma = $sigma")
println("lambda = $lambda")

# n = 66
# sigma = 0.001299955128841397
# lambda = 591756.8261100481

range = (2.994,3.008)

figure(1); clf(); hold(true)
plot(x)
title("Sequence of measurements",fontsize=16)
ylabel("speed (\$\\times 10^8\$ meters/second)",fontsize=14)
xlabel("measurement #",fontsize=14)
draw_now()
savefig("newcomb-sequence.png",dpi=120)


figure(2); clf(); hold(true)
plt.hist(x,49,range)
title("Histogram (speed of light measurements)",fontsize=16)
ylabel("count",fontsize=14)
xlabel("speed (\$\\times 10^8\$ meters/second)",fontsize=14)
draw_now()
savefig("newcomb-histogram.png",dpi=120)


# posterior distribution
figure(3); clf(); hold(true)
t = linspace(range[1],range[2],1000)
plot(t,pdf(Normal(mean(x),1/sqrt(n*lambda)), t),label="using all data","b")

S = setdiff([1:66],6) # exclude outlier
plot(t,pdf(Normal(mean(x[S]),1/sqrt((n-1)*lambda)), t),label="excluding outlier","r")
ylim(0,2600)

plot([truth,truth],ylim(),"k--",linewidth=1.5,label="modern value")
legend(loc=0,labelspacing=0.5,fontsize=15) #names,fontsize=fontsize,numpoints=1,ncol=ncol)

title("Posterior (speed of light)",fontsize=16)
ylabel("\$p(\\theta|x_{1:n})\$",fontsize=16)
xlabel("speed (\$\\times 10^8\$ meters/second)",fontsize=14)
draw_now()
savefig("newcomb-posterior.png",dpi=120)









