using HomotopyContinuation, CSV, DataFrames
# vars
@var q1 q2 p

# parameters
# a is some intercept for demand, it should be downward sloping ofc
a, b = 100, 0.1

# arbitrary costs that the two firms have.
c1, c2 = 10, 12

# 3. follower's FOC (The constraint)
# f = d(Profit2)/dq2
f = (a - b*(q1 + q2)^2) - 2*b*q2*(q1 + q2) - c2

# building the Leader's Equation using the implicit derivative logic, I am pretty sure you can do this in julia...
# Derivatives for the Chain Rule
dpi1_dq1 = (a - b*(q1 + q2)^2) - 2*b*q1*(q1 + q2) - c1
dpi1_dq2 = -2*b*q1*(q1 + q2)
df_dq1   = -2*b*(q1 + q2) - 2*b*q2
df_dq2   = -2*b*(q1 + q2) - 2*b*(q1 + q2) - 2*b*q2 # Partial of f w.r.t q2

# leader's eq: (dpi1/dq1 * df/dq2) - (dpi1/dq2 * df/dq1) = 0
g = dpi1_dq1 * df_dq2 - dpi1_dq2 * df_dq1

system = System([f, g])
result = solve(system)
print(result)
# solutions(result)

# filter for real, positive solutions
values = HomotopyContinuation.real_solutions(result)
# print(values)

economic_solutions = filter(s -> all(x -> x > 0, s), values)

println("Found $(length(economic_solutions)) viable Stackelberg equilibria:")
for sol in economic_solutions
    println("q1 (Leader): $(round(sol[1], digits=4)), q2 (Follower): $(round(sol[2], digits=4))")
end


# we are going to have to do it by trackerpath in order to get our data
println("================ Reading Path Data ==================")

F = System([f, g]; parameters=[p])

# 2. Get start solutions at p = 0 (where the system is linear/simple)
# At p=0, our construction makes q1 and q2 easy to solve
start_sols = solutions(solve(F, target_parameters=[0.0]))

# 3. Construct the Parameter Tracker
# This tracks from p=0 (start) to p=1 (target system)
trck = Tracker(ParameterHomotopy(F, [0.0], [1.0]))

start_sols = solutions(solve(F, target_parameters=[0.0]))

df = DataFrame(path_id=Int[], step=Int[], q1_re=Float64[], q1_im=Float64[], q2_re=Float64[], q2_im=Float64[])

for (p_idx, s0) in enumerate(start_sols)
    # We use the iterator here just like we did with the manual start solutions!
    for (x, t) in iterator(trck, s0, 1.0, 0.0)
        push!(df, (
            p_idx, 
            length(filter(r -> r.path_id == p_idx, eachrow(df))) + 1, 
            real(x[1]), imag(x[1]), 
            real(x[2]), imag(x[2])
        ))
    end
end

CSV.write("stackelberg_paths_final.csv", df)
