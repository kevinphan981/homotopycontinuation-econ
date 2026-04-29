using HomotopyContinuation, CSV, DataFrames
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
# tracker = Tracker(system)
# tracker = HomotopyContinuation.pathtracker(system)

results = solve(system, start_system = :total_degree)
sol_values = HomotopyContinuation.real_solutions(results)

positive_sols = filter(s -> all(x -> x > 0, s), sol_values) #what we want.

println("\n========== Solutions with Total Degree Homotopy ==========\n")
print(positive_sols)

# getting the data in a different way...

F = System([F1_poly, F2_poly, eqZ])
# G = System([px^10 - 1, py^10 - 1, Z^6 - 1])

println("\n=============== Reading Path Data =================\n")
# This is what solve() does internally to get 78 instead of 600?
what = HomotopyContinuation.total_degree(F)

eg_tracker, start_sols = HomotopyContinuation.total_degree(F)

# we actually have the paths
core_tracker = eg_tracker.tracker


# trck = Tracker(prob)

# generate the 600 Start Solutions (roots of unity)
# px_s = [exp(im*2π*k/10) for k in 0:9]
# py_s = [exp(im*2π*k/10) for k in 0:9]
# z_s  = [exp(im*2π*k/6) for k in 0:5]
# start_sols = [[p1, p2, z] for p1 in px_s, p2 in py_s, z in z_s][:]


# capture every step for every path
df = DataFrame(path_id=Int[], step=Int[], px_re=Float64[], px_im=Float64[], 
               py_re=Float64[], py_im=Float64[], z_re=Float64[], z_im=Float64[])


println("Tracking $(length(start_sols)) optimized paths...")
# println("Tracking 600 paths... this may take a moment.")

for (p_idx, s0) in enumerate(start_sols)
    step_num = 1
    for (x, t) in iterator(core_tracker, s0, 1.0, 0.0)
        # Note: Order of x follows @var px py Z
        push!(df, (p_idx, step_num, 
                   real(x[1]), imag(x[1]), 
                   real(x[2]), imag(x[2]), 
                   real(x[3]), imag(x[3])))
        step_num += 1
    end
end

CSV.write("bertrand_paths_full.csv", df)