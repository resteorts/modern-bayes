

using PyPlot
function draw_now(number = 0)
    if number>0; figure(number); end
    pause(0.001) # this forces the figure to update (draw() is supposed to do this, but doesn't work for me)
    get_current_fig_manager()[:window][:raise_]() # bring figure window to the front
end

f(t,a,b) = (t.^(a-1).*(1-t).^(b-1))/beta(a,b)
t = linspace(0,1,1000)

if true
    figure(1,figsize=(5,4)); clf(); hold(true)
    a=1; b=1; plot(t,f(t,a,b),linewidth=2,label="\$a=$a, \\, b=$b\$","b")
    a=2; b=2; plot(t,f(t,a,b),linewidth=2,label="\$a=$a, \\, b=$b\$","g")
    a=4; b=4; plot(t,f(t,a,b),linewidth=2,label="\$a=$a, \\, b=$b\$","m")
    a=0.5; b=0.5; plot(t,f(t,a,b),linewidth=2,label="\$a=$a, \\, b=$b\$","y")
    a=0.5; b=2; plot(t,f(t,a,b),linewidth=2,label="\$a=$a, \\, b=$b\$","r")
    legend(loc=9,labelspacing=0) #names,fontsize=fontsize,numpoints=1,ncol=ncol)
    ylim(0,5)
    xlabel(L"$\theta$",fontsize=16)
    ylabel(L"$\mathrm{Beta}(\theta|a,b)$",fontsize=16)
    draw_now()
    savefig("Beta.png",dpi=120)
end

# Example
if false
theta = 0.51
ns = [0,10,50,250,1000]
a0=1; b0=1
colors = ["k","b","g","y","r"]
X = (rand(maximum(ns)).<theta)

# figure(2,figsize=(5,4)); clf(); hold(true)
figure(2); clf(); hold(true)
for (i,n) in enumerate(ns)
    a = a0 + sum(X[1:n])
    b = b0 + n-sum(X[1:n]) 
    # plot(t,f(t,a,b),linewidth=2,label=@sprintf("a=%.0f, b=%.0f",a,b),colors[i])
    label = "\$n = $n\$"
    plot(t,f(t,a,b),linewidth=2,label=label,colors[i])
    legend(loc=1,fontsize=20) #names,fontsize=fontsize,numpoints=1,ncol=ncol)
    # ylim(0,5)
    plot([theta,theta],[0,ylim()[2]],"k--")
    xticks(0:0.1:1)
    xlabel(L"$\theta$",fontsize=20)
    ylabel(L"$p(\theta|x_{1:n})$",fontsize=20)
    draw_now()
    savefig("posterior.png",dpi=120)
    
end
end










