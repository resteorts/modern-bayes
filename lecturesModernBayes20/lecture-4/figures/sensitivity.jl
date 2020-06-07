# WARNING: If this file is edited, paper.tex may also need to be updated.

using PyPlot
draw_now() = (pause(0.001); get_current_fig_manager()[:window][:raise_]())

# Beta density
f(t,a,b) = exp((a-1)*log(t) + (b-1)*log(1-t) - lbeta(a,b))
dt = 1/1000
t = [dt:dt:1]

# Data
n = 30
s = 0

ab = [(1,25),(1,1),(0.2,5),(2,50)]
colors = ["b","g","y","m"]

figure(2); clf(); hold(true)
for (i,(a,b)) in enumerate(ab)
    # Prior: Beta(a,b)

    # Posterior: Beta(A,B)
    A = a + s
    B = b + n - s
    p_t = f(t,A,B)

    # Loss function
    loss(theta,theta_hat) = abs(theta-theta_hat).*(1.0 + 9.0*(theta_hat.<theta))

    # Posterior expected loss
    # rho = [mean(loss(t,theta_hat).*p_t)::Float64 for theta_hat in t]
    rho(theta_hat) = sum(loss(t,theta_hat).*p_t*dt)

    # Plot posterior expected loss
    rhos = [rho(th)::Float64 for th in t]
    plot(t,rhos,label="\$a = $a,\$ \$b = $b\$",linewidth=2,colors[i])
    draw_now()

    # Find minimizer
    println(t[indmin(rhos)])
end
xlim(0,0.3)
ylim(0,0.3)
xlabel("\$c\$",fontsize=20)
ylabel("\$\\rho(c,x)\$",fontsize=20)
legend(loc=4,fontsize=18)

# Save figure
savefig("sensitivity.png",dpi=120)






