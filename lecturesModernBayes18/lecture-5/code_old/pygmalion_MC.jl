# Analyze data from the Pygmalion study using Normal-NormalGamma model
module Pygmalion

using PyPlot, Distributions
draw_now() = (pause(0.001); get_current_fig_manager()[:window][:raise_]())

# treatment group
x = [18, 40, 15, 17, 20, 44, 38]
# control group
y = [-4, 0, -19, 24, 19, 10, 5, 10, 29, 13, -9, -8, 20, -1, 12, 21, -7, 14,
     13, 20, 11, 16, 15, 27, 23, 36, -33, 34, 13, 11, -19, 21, 6, 25, 30,
     22, -28, 15, 26, -1, -2, 43, 23, 22, 25, 16, 10, 29]

m = 0
c = 1
a = 1/2
b = 10^2*a


function NormalGamma_posterior(x,m,c,a,b)
    mx = mean(x)
    vx = mean((x-mx).^2)
    n = length(x)
    C = c + n
    A = a + n/2
    M = (c*m + n*mx)/C
    B = b + 0.5*n*vx + 0.5*(c*n/C)*(mx-m)^2
    return M,C,A,B,mx,vx
end

function NormalGamma_sample(n,m,c,a,b)
    lambda = rand(Gamma(a,1/b),n)
    mu = rand(Normal(0,1),n)./sqrt(c*lambda) + m
    return (mu,lambda)
end

Mx,Cx,Ax,Bx,mx,vx = NormalGamma_posterior(x,m,c,a,b)
My,Cy,Ay,By,my,vy = NormalGamma_posterior(y,m,c,a,b)
sx,sy = sqrt(vx),sqrt(vy)



lower,upper = -52.5,52.5
edges = lower:5:upper
bins = midpoints(edges)


# Compute posterior quantities
Ns = [10:10:2000]
Nmax = maximum(Ns)
probabilities = zeros(length(Ns))

figure(3,figsize=(10,4)); clf(); hold(true)
subplots_adjust(bottom = 0.2)
for reps = 1:3
    mu_x,lambda_x = NormalGamma_sample(Nmax,Mx,Cx,Ax,Bx)
    mu_y,lambda_y = NormalGamma_sample(Nmax,My,Cy,Ay,By)
    for (i,N) in enumerate(Ns)
        probabilities[i] = mean(mu_x[1:N].>mu_y[1:N])
    end
    plot(Ns,probabilities,linewidth=2)
end

p = 0.97
s = sqrt(p*(1-p))
plot(Ns,p-s./sqrt(Ns),"k--")
plot(Ns,p+s./sqrt(Ns),"k--")
ylim(0.9,1.0)

xlabel("\$N\$  (# of Monte carlo samples)",fontsize=15)
ylabel("approx of \$P(\\mu_S > \\mu_C |\\,data)\$",fontsize=15)
draw_now()
savefig("pygmalion-MC.png",dpi=120)






end

