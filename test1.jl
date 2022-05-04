using Plots
using LaTeXStrings
using Random
using PyCall
using Printf
using LinearAlgebra
include("function.jl")



#################TEST##################
NoExp = 10
Ntimes = 1000
learningRate = 0.01
SystemDim = 20
SignalPower = 1.
SNR = 20
NormDevAv = zeros(Ntimes)
alphaLevy = 1.5
betaLevy = 0.5
muLevy = 0.
sigmaLevy = 0.1

for Exp=1:NoExp
	global NormDevAv
	@printf "Test #%i" Exp
	thetaStar = randn(SystemDim)
	thetaStar = thetaStar/norm(thetaStar)
	X = sqrt(SignalPower)*randn(SystemDim,Ntimes)
	Noise = randn(Ntimes)
	NoisePower = SignalPower*10^(-SNR/10)
	Levy = pyimport("levy")
	Outliers = Levy.random(alphaLevy, betaLevy, muLevy, sigmaLevy, shape=(Ntimes))
	y = X'*thetaStar + sqrt(NoisePower)*Noise + Outliers
	NormDev = Vector{Float64}(undef, Ntimes)
	
	Theta = randn(SystemDim)
	for n=1:Ntimes
		NewTheta = LMS(X[:,n],y[n],Theta,learningRate)
		Theta = NewTheta
		NormDev[n] = norm(thetaStar - Theta)
	end
	@printf "done\n"
	NormDevAv = (Exp-1)*NormDevAv/Exp + NormDev/Exp
end

# Plot
p = plot()
plot_font = "Computer Modern";
default(fontfamily = plot_font,#
        framestyle = :box,#
        grid = false,#
        # tickfontsize = 7,#
        )
plot!(1:Ntimes,#
      NormDevAv,#
      label = L"\textrm{RL}",#
      xlabel = "Iteration/time index",#
      ylabel = "Normalized deviation",#
      yaxis = :log10,#
      # ylims = (5e-2, Inf),#
      lw = 2,#
      color = :black,#
      legend = :outertopright,#
      );
display(p)
figname = "LMS.png"
savefig(figname)
