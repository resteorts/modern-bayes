# WARNING: If this file is edited, paper.tex may also need to be updated.

using PyPlot, Distributions
draw_now() = (pause(0.001); get_current_fig_manager()[:window][:raise_]())

# Beta density
f(t,a,b) = exp((a-1)*log(t) + (b-1)*log(1-t) - lbeta(a,b))
dt = 1/5000
t = [dt/2:dt:1-dt/2]

# Data
n = 30

# Prior: Beta(a,b)
a = 0.05
b = 1.0
prior_t = f(t,a,b)

# Loss function
loss(theta,theta_hat) = abs(theta-theta_hat).*(1.0 + 9.0*(theta_hat.<theta))

# Decision procedures, as a function of Z=sum(X)
delta_average = [0:n]/n  # mean(x)
delta_constant = 0.1*ones(n+1)  # constant

# Note!!! This is not accurate for z=0, due to the density going to infinity!!!
# However, this should only affect the risk curve slightly near 0.
function Bayes_procedure(z)
    A = a + z
    B = b + n - z
    p_t = f(t,A,B)
    rho(theta_hat) = sum(loss(t,theta_hat).*p_t*dt)
    rhos = [rho(th)::Float64 for th in t]
    if z==0; println(sum(p_t*dt)," ",t[indmin(rhos)]); end
    return t[indmin(rhos)]
end
delta_Bayes = [Bayes_procedure(z)::Float64 for z=0:n]

# Risk
R(theta,delta) = sum(loss(theta,delta).*pdf(Binomial(n,theta),0:n))

risk_constant = [R(ti,delta_constant)::Float64 for ti in t]
risk_average = [R(ti,delta_average)::Float64 for ti in t]
risk_Bayes = [R(ti,delta_Bayes)::Float64 for ti in t]

# Plot risk curves
figure(1); clf(); hold(true)
plot(t,risk_constant,label="constant",linewidth=2,"r")
plot(t,risk_average,label="sample mean",linewidth=2,"g")
plot(t,risk_Bayes,label="Bayes",linewidth=2,"b")
ylim(0,1)
#xlim(0,0.5)
xlabel("\$\\theta\$",fontsize=20)
ylabel("risk, \$R(\\theta,\\delta)\$",fontsize=20)
legend(loc=1,fontsize=16)
draw_now()
# Save figure
savefig("risk.png",dpi=120)

# Plot procedures
figure(2); clf(); hold(true)
plot([0:n],delta_constant,label="constant",linewidth=2,"ro-")
plot([0:n],delta_average,label="sample mean",linewidth=2,"go-")
plot([0:n],delta_Bayes,label="Bayes",linewidth=2,"bo-")
# ylim(0,1)
#xlim(0,0.5)
xlabel("observed number of diseased cases",fontsize=18)
ylabel("resources allocated",fontsize=18)
legend(loc=2,fontsize=16,numpoints=1)
draw_now()
# Save figure
savefig("procedures.png",dpi=120)

# Integrated risk
println("Integrated risk")
println("constant: ",sum(risk_constant.*prior_t*dt))
println("sample mean: ",sum(risk_average.*prior_t*dt))
println("Bayes: ",sum(risk_Bayes.*prior_t*dt))








