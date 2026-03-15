using HomotopyContinuation
using Plots

# the extremely simple case (using linear examples)

# @var p1 p2    # extend to more prices as needed

# FOCs for linear differentiated duopoly, very simple
# # parameters (you would choose numbers for these)
# α1, α2 = 100.0, 80.0
# β11, β22 = 2.0, 1.5
# β12, β21 = 1.0, 0.5
# c1, c2 = 10.0, 12.0

# q1 = α1 - β11*p1 + β12*p2
# q2 = α2 - β22*p2 + β21*p1

# f1 = q1 + (p1 - c1)*(-β11)
# f2 = q2 + (p2 - c2)*(-β22)

# F = System([f1, f2])

# result = solve(F)

# solutions(result)

# the case from the thesis which is more rigorous
# variables
@var px py Z

# parameters, which we don't use yet
A = 50
n = 2700
m = 1

# clear denominators (important!)
F1_poly = -2700 + 2700*px + 8100Z^2*px^2 - 5400Z^2*px^3 + 51Z^3*px^6 - 2Z^3*px^7
F2_poly = -2700 + 2700*py + 8100Z^2*py^2 - 5400Z^2*py^3 + 51Z^3*py^6 - 2Z^3*py^7

# Z definition (polynomialized)
eqZ = Z^2 * px^2 * py^2 - (px^2 + py^2)

system = System([F1_poly, F2_poly, eqZ])
results2 = solve(system)
values = real_solutions(results2)

positive_sols = filter(s -> all(x -> x > 0, s), values) #what we want.

# points = reduce(hcat, positive_sols)'  # n×d matrix, n solutions in d dimensions
# # 2D scatter on plane (quick), but doesn't say much
# scatter(points[:,1], points[:,2], markersize=5, label="Positive solutions")

