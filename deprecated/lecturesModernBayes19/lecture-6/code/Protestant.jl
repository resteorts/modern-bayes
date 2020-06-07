module Protestant

using PyPlot, Distributions
draw_now() = (pause(0.001); get_current_fig_manager()[:window][:raise_]())


#\btheta_p^{(1)}\,\dotsc,\btheta_p^{(N)}\sim \Beta(354,659)\\
#\btheta_n^{(1)}\,\dotsc,\btheta_n^{(N)}\sim \Beta(442,420)

N = 10^6
theta_p = rand(Beta(354,659),N)
theta_n = rand(Beta(442,420),N)
x = theta_n./theta_p

lower,upper = 1,2

# Histograms
figure(1,figsize=(10,4)); clf(); hold(true)
edges = [lower:0.01:upper]
ticks = lower:0.1:upper
#plt.hist(x,100)
edges,cx = hist(x,edges)
bar(edges[1:end-1],cx./(N*diff(edges)),diff(edges))
xlabel("\$\\theta_n/\\theta_p\$  (how many times as likely to agree)",fontsize=16)
ylabel("posterior density",fontsize=14)
subplots_adjust(bottom = 0.2)
xticks(ticks)
xlim(minimum(ticks),maximum(ticks))
ylim(0,6)
grid(true)
#legend(loc=6,numpoints=1,labelspacing=0.1,fontsize=15) #names,fontsize=fontsize,numpoints=1,ncol=ncol)
draw_now()
savefig("Protestant.png",dpi=120)


end

