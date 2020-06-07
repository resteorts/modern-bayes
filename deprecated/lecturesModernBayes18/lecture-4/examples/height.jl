# Load and plot the self-reported height and weight data from selfreport.dat
# Data obtained from the MICE package in R:
# http://artax.karlin.mff.cuni.cz/r-help/library/mice/html/selfreport.html
module Heights

using PyPlot, Distributions
draw_now() = (pause(0.001); get_current_fig_manager()[:window][:raise_]())

data = readdlm("selfreport.dat",' ')
subset = 804:2060  # Use only Krul data
age = convert(Array{Float64,1},data[subset+1,3])
gender = convert(Array{ASCIIString,1},data[subset+1,4])
mh = convert(Array{Float64,1},data[subset+1,5])
sh = convert(Array{Float64,1},data[subset+1,7])

x = mh[gender.=="Female"]
y = mh[gender.=="Male"]
n_x = length(x)
n_y = length(y)
println("Sample mean of female heights = ",mean(x))
println("Sample mean of male heights =",mean(y))

lower,upper = 140,215

# Distribution of measured heights - male and female
figure(1,figsize=(10,4)); clf(); hold(true)
edges = lower:2.5:upper
edges,female = hist(x,edges)
edges,male = hist(y,edges)
bins = midpoints(edges)
female_density = female./(n_x*diff(edges))
male_density = male./(n_y*diff(edges))
plot(midpoints(edges),female_density,"b",label="female",linewidth=2)
plot(midpoints(edges),male_density,"r",label="male",linewidth=2)
# title("Heights, female and male")
xlabel("height (cm)",fontsize=14)
ylabel("estimated density",fontsize=14)
subplots_adjust(bottom = 0.2)
xticks(lower:5:upper)
xlim(lower,upper)
grid(true)
legend(numpoints=1,loc=5,labelspacing=0.1,fontsize=15) #names,fontsize=fontsize,numpoints=1,ncol=ncol)
# tick_params(axis="x",direction="out",top="off")
draw_now()
# savefig("heights-female-male.png",dpi=120)

# Distribution of measured heights - combined
figure(2,figsize=(10,4)); clf(); hold(true)
edges,combined = hist(mh,edges)
bins = midpoints(edges)
plot(midpoints(edges),female_density/2+ male_density/2,"k",label="combined",linewidth=2)
xlabel("height (cm)",fontsize=14)
ylabel("estimated density",fontsize=14)
subplots_adjust(bottom = 0.2)
xticks(lower:5:upper)
xlim(lower,upper)
grid(true)
# tick_params(axis="x",direction="out",top="off")
draw_now()
# savefig("heights-combined.png",dpi=120)

# Fix standard deviations to empirical values
# (This is far from ideal, but let's do it for simplicity for now.)
lambda_f = 1/var(x)
lambda_m = 1/var(y)
lambda = 1/8^2 #1/mean([x-mean(x),y-mean(y)].^2)

# Posterior
M(x,lambda,mu_0,lambda_0) = (lambda_0*mu_0 + lambda*sum(x))/(lambda_0 + length(x)*lambda)
L(x,lambda,mu_0,lambda_0) = (lambda_0 + length(x)*lambda)

# Data: X_1,...,X_n ~ N(theta,1/lambda)
# Prior: theta ~ N(mu_0, 1/lambda_0)
# Females
mu_0_f = 165 # 165 cm ~ 5 foot 5 inches
lambda_0_f = 1/15^2 # 15 cm ~ 6 inches 
# Males
mu_0_m = 178 # 178 cm ~ 5 foot 10 inches
lambda_0_m = 1/15^2 # 15 cm ~ 6 inches 

# Posterior: theta ~ N(M,1/L)
# Females
M_f = M(x,lambda,mu_0_f,lambda_0_f)
L_f = L(x,lambda,mu_0_f,lambda_0_f)
# Males
M_m = M(y,lambda,mu_0_m,lambda_0_m)
L_m = L(y,lambda,mu_0_m,lambda_0_m)


# Line plots of priors and posteriors - male and female
figure(3,figsize=(10,4)); clf(); hold(true)
t = linspace(lower,upper,1000)
plot(t,pdf(Normal(mu_0_f,1/sqrt(lambda_0_f)),t),"b--",label="female, prior",linewidth=2)
plot(t,pdf(Normal(M_f,1/sqrt(L_f)),t),"b",label="female, posterior",linewidth=2)
plot(t,pdf(Normal(mu_0_m,1/sqrt(lambda_0_m)),t),"r--",label="male, prior",linewidth=2)
plot(t,pdf(Normal(M_m,1/sqrt(L_m)),t),"r",label="male, posterior",linewidth=2)
# title("Heights, female and male")
xlabel("\$\\theta\$  (mean height, cm)",fontsize=14)
ylabel("\$p(\\theta\\mid \\,data)\$",fontsize=16)
subplots_adjust(bottom = 0.2)
xticks(140:5:215)
xlim(140,215)
ylim(0,1.5)
grid(true)
legend(numpoints=1,loc=5,labelspacing=0.1,fontsize=15) #names,fontsize=fontsize,numpoints=1,ncol=ncol)
# tick_params(axis="x",direction="out",top="off")
draw_now()
# savefig("heights-prior-posterior.png",dpi=120)

# For simplicity, assume males and females occur in equal proportion in the overall population, and assume the standard deviations are both sigma. Then the combined distribution is bimodal iff the means differ by more than 2 sigma.
# The more general formula is given by ...

sigma = 1/sqrt(lambda)
D = Normal(M_m-M_f,sqrt(1/L_m+1/L_f))
pbimodal = cdf(D,-2*sigma) + 1-cdf(D,2*sigma)
println("P(bimodal|data) = $pbimodal")

N = 10^6
z_f = rand(Normal(M_f,1/sqrt(L_f)),N)
z_m = rand(Normal(M_m,1/sqrt(L_m)),N)
fraction = mean(abs(z_f-z_m) .> 2*sigma)
println(sigma)
println(@sprintf("P(bimodal|data) = %.15f",fraction))
println(mean(abs(z_f-z_m)))
println(M_m-M_f)
println("Posterior mean for females = ",M_f)
println("Posterior mean for males   = ",M_m)
println("mean of difference = $(M_m-M_f)")
println("stddev of difference = $(sqrt(1/L_m+1/L_f))")
#println([z_f z_m])

println("Posterior precision for females = $L_f  (standard deviation = $(1/sqrt(L_f))")
println("Posterior precision for males   = $L_m  (standard deviation = $(1/sqrt(L_m))")



end # module




