#  Uniform samples for rejection sampling example figure
module reject

using PyPlot, Distributions
draw_now() = (pause(0.001); get_current_fig_manager()[:window][:raise_]())


figure(1,figsize=(8,5)); clf(); hold(true)
n = 50
U,V = rand(n),rand(n)
plot(U,V,"b.")
# axis("equal")
xticks([])
yticks([])
draw_now()
savefig("reject.png",dpi=120)




end
