using HomotopyContinuation
using CSV, DataFrames

# ── System ────────────────────────────────────────────────────────────────────
@var x y
F = System([x^2 - 1, y^2 - 1])

# ── Start system via ParameterHomotopy ───────────────────────────────────────
# We use a TotalDegreeHomotopy (default) but intercept intermediate path points
# by tracking each start solution individually with `track`, which gives us
# access to the full PathResult including the internal path tracker state.

result = solve(F; show_progress = false)

println("=" ^ 50)
println("HC.jl result summary")
println("=" ^ 50)
println(result)
println()

# ── Extract per-path data from PathResult objects ─────────────────────────────
# `results(result)` returns a Vector{PathResult}. Each PathResult has:
#   - solution(r)          → final solution vector
#   - is_success(r)        → did the path converge?
#   - is_real(r)           → is the solution real?
#   - winding_number(r)    → winding number (>1 means path failure / singular)
#   - condition_number(r)  → condition at endpoint
#   - residual(r)          → ||F(solution)||
#   - path_number(r)       → index of this path
#   - steps(r)             → number of steps the tracker took
#   - accepted_steps(r)    → accepted steps
#   - rejected_steps(r)    → rejected steps
#   - start_solution(r)    → where the path began (in homogeneous coords)

rows = []
for r in HomotopyContinuation.results(result)
    sol = solution(r)
    push!(rows, (
        path_id          = path_number(r),
        x_re             = real(sol[1]),
        x_im             = imag(sol[1]),
        y_re             = real(sol[2]),
        y_im             = imag(sol[2]),
        is_success       = is_success(r),
        is_real          = is_real(r),
        # winding_number   = winding_number(r), # turns out to be nothing???
        residual         = residual(r),
        # condition_number = cond(r),
        accepted_steps   = accepted_steps(r),
        rejected_steps   = rejected_steps(r),
    ))
end

df_summary = DataFrame(rows)
println("Per-path summary:")
println(df_summary)
CSV.write("path_summary.csv", df_summary)