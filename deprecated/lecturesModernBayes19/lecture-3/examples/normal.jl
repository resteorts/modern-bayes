
using PyPlot, Distributions
draw_now() = (pause(0.001); get_current_fig_manager()[:window][:raise_]())

x = linspace(-6,6,1000)

figure(1); clf(); hold(true)
m=0; s=1; plot(x,pdf(Normal(m,s),x),linewidth=2,label="\$\\mu=$m,\\,\\sigma=$s\$","b")
m=0; s=2; plot(x,pdf(Normal(m,s),x),linewidth=2,label="\$\\mu=$m,\\,\\sigma=$s\$","r")
m=-1; s=0.75; plot(x,pdf(Normal(m,s),x),linewidth=2,label="\$\\mu=$m,\\,\\sigma=$s\$","g")
m=2; s=0.5; plot(x,pdf(Normal(m,s),x),linewidth=2,label="\$\\mu=$m,\\,\\sigma=$s\$","y")
ylabel("\$N(x\\mid\\,\\mu,\\sigma^2)\$",fontsize=14)
xlabel("\$x\$",fontsize=14)
ylim(0,0.85)
legend(loc=2,labelspacing=0.1,fontsize=15) #names,fontsize=fontsize,numpoints=1,ncol=ncol)
draw_now()
savefig("normal.png",dpi=120)





