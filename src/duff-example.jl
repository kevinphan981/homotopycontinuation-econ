# you love to see it

using HomotopyContinuation
using Plots # can I plot it?

# I use the first example from https://timduff35.github.io/timduff35/sc.pdf
#declare
@var x, y

#define polynomials
f1 = (4x^2*y + x*y) - 3y
f2 =  y^2 - 2x + 1

# create a systems of equations
F = System([f1, f2])

#solve
result = solve(F, start_system = :total_degree)
solutions(result)

# retrieves only the real solutions in form of a vector
# real_solutions(result)
