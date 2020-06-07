# Load and plot the self-reported height and weight data from selfreport.dat
# Data obtained from the MICE package in R:
# http://artax.karlin.mff.cuni.cz/r-help/library/mice/html/selfreport.html
module HeightsPosterior

using PyPlot, Distributions
draw_now() = (pause(0.001); get_current_fig_manager()[:window][:raise_]())

data = readdlm("selfreport.dat",' ')
lower,upper = 140,215

# Data: X_1,...,X_{n_g} ~ N(theta,1/lambda)
# Prior: theta ~ N(mu_0, 1/lambda_0)
# Females
mu_0_f = 165 # 165 cm ~ 5 foot 5 inches
lambda_0_f = 1/15^2 # 15 cm ~ 6 inches 
# Males
mu_0_m = 178 # 178 cm ~ 5 foot 10 inches
lambda_0_m = 1/15^2 # 15 cm ~ 6 inches 


figure(3,figsize=(10,4)); clf(); hold(true)
subplots_adjust(bottom = 0.2)

ns = int(logspace(1,3,10)) #[10:10:90,100:100:1000]
reps = 1:2000
probabilities = Array(Float64,length(reps),length(ns))
for rep in reps
    for n in ns

        subset = shuffle([804:2060])[1:n]  # Use only Krul data
        age = convert(Array{Float64,1},data[subset+1,3])
        gender = convert(Array{ASCIIString,1},data[subset+1,4])
        mh = convert(Array{Float64,1},data[subset+1,5])
        sh = convert(Array{Float64,1},data[subset+1,7])

        x = mh[gender.=="Female"]
        y = mh[gender.=="Male"]

        # Fix standard deviations to empirical values
        # (This is far from ideal, but let's do it for simplicity for now.)
        lambda_f = 1/var(x)
        lambda_m = 1/var(y)
        lambda = 1/8^2 #1/mean([x-mean(x),y-mean(y)].^2)

        # Posterior quantities
        M(x,lambda,mu_0,lambda_0) = (lambda_0*mu_0 + lambda*sum(x))/(lambda_0 + length(x)*lambda)
        L(x,lambda,mu_0,lambda_0) = (lambda_0 + length(x)*lambda)

        # Posterior: theta ~ N(M,1/L)
        # Females
        M_f = M(x,lambda,mu_0_f,lambda_0_f)
        L_f = L(x,lambda,mu_0_f,lambda_0_f)
        # Males
        M_m = M(y,lambda,mu_0_m,lambda_0_m)
        L_m = L(y,lambda,mu_0_m,lambda_0_m)


        # For simplicity, assume males and females occur in equal proportion in the overall population, and assume the standard deviations are both sigma. Then the combined distribution is bimodal iff the means differ by more than 2 sigma.
        # The more general formula is given by ...

        N = 10^5
        sigma = 1/sqrt(lambda)
        z_f = rand(Normal(M_f,1/sqrt(L_f)),N)
        z_m = rand(Normal(M_m,1/sqrt(L_m)),N)
        fraction = mean(abs(z_f-z_m) .> 2*sigma)
        probabilities[rep,findfirst(ns.==n)] = fraction
        # println(sigma)
        # println(@sprintf("P(bimodal|data) = %.6e",fraction))
        # println(mean(abs(z_f-z_m)))
        # println(M_m-M_f)
    end
end
plot(ns,mean(probabilities,1)[:],"go-",linewidth=2)
xlabel("\$n\$  (total sample size)",fontsize=14)
ylabel("mean P(bimodal | data)",fontsize=14)
draw_now()
savefig("heights-bimodal.png",dpi=120)



end




