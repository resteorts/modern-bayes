
using PyPlot, Distributions
draw_now() = (pause(0.001); get_current_fig_manager()[:window][:raise_]())

# Beta density
f(t,a,b) = exp((a-1)*log(t) + (b-1)*log(1-t) - lbeta(a,b))

# Data
n = 104490000
x = 52263471

# Prior: Beta(a,b)
# Posterior: Beta(a+x,b+n-x)

# Plot posterior
epsilon = 0.0004
t = linspace(0.5-epsilon,0.5+epsilon,1000)
figure(1); clf(); hold(true)
# a=1e-3; b=1e-3; plot(t,f(t,a+x,b+n-x),linewidth=2,label="\$a=$a, \\, b=$b\$","r")
a=1; b=1; plot(t,f(t,a+x,b+n-x),linewidth=2,label="\$a=$a, \\, b=$b\$","b")
a=1e7; b=1e7; plot(t,f(t,a+x,b+n-x),linewidth=2,label="\$a=$a, \\, b=$b\$","g")
# xlim(0,0.5)
# ylim(0,0.5)
xlabel("\$\\theta\$",fontsize=20)
ylabel("\$\p(\\theta|x)\$",fontsize=20)
xticks(0.5-epsilon:0.0002:0.5+epsilon,0.5-epsilon:0.0002:0.5+epsilon)

# p-value
sigma = sqrt(0.25/n)
z = (x/n-0.5)/sigma
p_value = 2*cdf(Normal(0,1),-abs(z))
println("z = ",z)
println("p-value = ",p_value)
# z = 3.6139574868319055
# p-value = 0.0003015585296699075

# 95% confidence interval
lower,upper = x/n + [-1,1]*1.96*sigma
println("95% confidence interval = [$lower, $upper]")
plot([lower,lower],[0,ylim()[2]],linewidth=2,"k-.",label="95% confidence interval")
plot([upper,upper],[0,ylim()[2]],linewidth=2,"k-.")

# posterior probability of this interval
a=1; b=1
posterior = cdf(Beta(a+x,b+n-x),upper) - cdf(Beta(a+x,b+n-x),lower)
println("Posterior probability of this interval = ",posterior)

title("ESP experiment")
legend(loc=0,labelspacing=0.5,fontsize=15) #names,fontsize=fontsize,numpoints=1,ncol=ncol)
draw_now()

# Save figure
savefig("ESP.png",dpi=120)

logsumexp(a,b) = (m = max(a,b); m == -Inf ? -Inf : log(exp(a-m) + exp(b-m)) + m)

# Bayesian hypothesis test
println("Bayesian hypothesis test:")
p0 = 0.5
p1 = 0.5
for (a,b) in [(0.5,0.5),(1,1),(10,10),(100,100),(1000,1000),(10^4,10^4),(10^10,10^10)]
    log_q0 = x*log(0.5) + (n-x)*log(0.5) + log(0.5)
    log_q1 = lbeta(a+x,b+n-x) - lbeta(a,b) + log(0.5)
    log_S = logsumexp(log_q0,log_q1)
    p0x = exp(log_q0-log_S)
    p1x = exp(log_q1-log_S)
    println("a,b = $a,$b")
    println("   P(H_0|x) = ",p0x)
    println("   P(H_1|x) = ",p1x)
    println()
end

















