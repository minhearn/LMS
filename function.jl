function chirp(x::Vector{Float64})
	L = [3,4,5]
	return L'*x
end

function LMS(X::Vector{Float64},#
	      y::Float64,#
	      theta::Vector{Float64},#
	      learningRate::Float64,#
	      )
	error = y - X'*theta
	theta = theta + learningRate*error*X
	
	return theta
end


