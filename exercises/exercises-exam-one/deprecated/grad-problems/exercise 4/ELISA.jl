
using PyPlot, Distributions
draw_now() = (pause(0.001); get_current_fig_manager()[:window][:raise_]())

theta_D = 3.5
theta_U = -0.5
sigma = 1.5
D = Normal(theta_D,sigma)
U = Normal(theta_U,sigma)

n_D = 5000
n_U = 5000
n = n_D + n_U
x_D = rand(D,n_D)
x_U = rand(U,n_U)

edges = linspace(-8,8,50)

figure(1,figsize=(10,4)); clf(); hold(true)
subplots_adjust(bottom = 0.2)
edges,counts = hist(x_D,edges)
plot(midpoints(edges),counts./(diff(edges)*n_D),"r",linewidth=2,label="diseased cases")
edges,counts = hist(x_U,edges)
plot(midpoints(edges),counts./(diff(edges)*n_U),"b",linewidth=2,label="undiseased cases")
#title("Empirical distribution of \$x\$ for diseased and undiseased",fontsize=16)
ylabel("density",fontsize=14)
xlabel("\$x\$  (antigen level)",fontsize=14)
ylim(0,0.3)
legend(loc=0,labelspacing=0.5,fontsize=15) #names,fontsize=fontsize,numpoints=1,ncol=ncol)
draw_now()
savefig("disease.png",dpi=120)





