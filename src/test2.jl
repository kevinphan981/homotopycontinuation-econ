using HomotopyContinuation

@var x y t
F = System([x^2 + y^2 - 3, 2x^2 + 0.5x*y + 3y^2 - 2])

# construct start system and homotopy
G = System(im * [x^2 - 1, y^2 - 1])
H = StraightLineHomotopy(G, F)
start_solutions = [[1,1], [-1,1], [1,-1], [-1,-1]]
# construct tracker

# tracker = Tracker(H)

# my poor attempts to get the actual path of each solution
# tracker = coretracker(H; max_step_size = 0.01) #parameters = p, start_parameters = a, target_parameters = b
# for (x, t) in iterator(tracker, x₁)
#     @show (x,t)
# end
# print(tracker)

# track each start solution separetely
path_result = track.(tracker, start_solutions; keep_steps = true) #t₁=1.0, t₀=0.0, keep_steps=true

trckr = Tracker(H)

# idea: captures all the data taken at each step when we iterate through the tracker and start_sol. Only takes one path at a time
function capture_trace(tracker, start_sol)
    trace = []
    # iterator(tracker, start, t_start, t_end)
    for (x, t) in iterator(tracker, start_sol, 1.0, 0.0)
        push!(trace, copy(x)) # CRITICAL: copy(x) saves the values
    end
    return trace
end

# broadcast to all solutions
all_traces = capture_trace.(Ref(trckr), start_solutions)

# # 2. To store the path for the first start solution
# path1 = []

# # 3. Use the iterator interface
# # This manually steps from t=1 to t=0
# for (x, t) in iterator(trckr, start_solutions[1], 1.0, 0.0)
#     push!(path1, copy(x)) # We 'copy' because x is a reused buffer
# end


# # This is the easiest way for multiple paths
# res = solve(G, F, start_solutions; keep_steps=true)

# # To get the steps for the first path:
# # Note: solve returns a 'PathResult', which DOES have a .steps field
# steps_path_1 = res[1].steps_eg
# println("---------- What is even going on --------")
# print(steps_path_1)



println("\n=======================RESULTS=======================\n")
# print(path1)
# println("# successfull: ", count(is_success, results))
# println(all_points)
print(all_traces)

# data formatting

using CSV, DataFrames

# Assuming 'all_traces' is your list of paths from the previous step
# all_traces = [[ [x1,y1], [x2,y2]... ], [ [x1,y1]... ], ...]

df = DataFrame(path_id=Int[], step=Int[], x_real=Float64[], x_imag=Float64[], y_real=Float64[], y_imag=Float64[])

for (p_idx, path) in enumerate(all_traces)
    for (s_idx, pt) in enumerate(path)
        push!(df, (p_idx, s_idx, real(pt[1]), imag(pt[1]), real(pt[2]), imag(pt[2])))
    end
end

CSV.write("homotopy_test_traces.csv", df)