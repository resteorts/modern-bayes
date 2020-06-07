module Toy

using PyPlot, Distributions
draw_now() = (pause(0.001); get_current_fig_manager()[:window][:raise_]())

F(x,theta) = 1 - exp(-theta*x)
rand_TExp(theta,c) = -(1/theta)*log(1-rand()*F(c,theta))
c = 2.0


#x = [rand_TExp(1,2)::Float64 for i = 1:10000]
#figure(1,figsize=(10,4)); clf(); hold(true)
#subplots_adjust(bottom = 0.2)
#plt.hist(x,100)
#draw_now()

#x = rand(Exponential(1/1),10000)
#figure(2,figsize=(10,4)); clf(); hold(true)
#subplots_adjust(bottom = 0.2)
#plt.hist(x,100)
#xlim(0,2)
#draw_now()


# Gibbs sampling
figure(1,figsize=(6.5,6)); clf(); hold(true)
x,y = 1.0,1.0
N = 5
for i=1:N
    xn = rand_TExp(y,c)
    plot([x,xn],[y,y],"k-")
    yn = rand_TExp(xn,c)
    plot([xn,xn],[y,yn],"k-")
    plot(x,y,"ko",markersize=20,markerfacecolor="w")
    plot(xn,yn,"ko",markersize=20,markerfacecolor="w")
    o = 0.035
    plt.annotate(s="$(i-1)",xy=(x-o/2,y-o),fontsize=16)
    plt.annotate(s="$i",xy=(xn-o/2,yn-o),fontsize=16)
    x,y = xn,yn
end
xlim(0,2)
ylim(0,2)
draw_now()
savefig("toy-numbered.png",dpi=120)


# Gibbs sampling
figure(2,figsize=(6.5,6)); clf(); hold(true)
x,y = 1.0,1.0
N = 10^4
xr = zeros(N)
yr = zeros(N)
for i=1:N
    x = rand_TExp(y,c)
    y = rand_TExp(x,c)
    xr[i] = x
    yr[i] = y
end
plot(xr,yr,"b.",markersize=2)
xlim(0,2)
ylim(0,2)
draw_now()
savefig("toy-scatter.png",dpi=120)

println(mean(xr.^2 .* yr.^2))


end
