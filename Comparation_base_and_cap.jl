using CSV
using DataFrames
using Plots

# === Read only the "with reactive limits" cases ===
df_base_with       = CSV.read("Base_case_with_limits.csv", DataFrame)
df_base_with_tr    = CSV.read("Base_case_with_limits_tripped.csv", DataFrame)
df_cap_with        = CSV.read("Cap_case_with_limits.csv", DataFrame)
df_cap_with_tr     = CSV.read("Cap_case_with_limits_tripped.csv", DataFrame)

# === Single plot for Part 3(c): realistic cases (with Q limits) ===
plot(
    df_base_with.lambda, df_base_with.V14_pu,
    label  = "Base, no cap, no outage",
    xlabel = "λ",
    ylabel = "|V₁₄| (p.u.)",
    legend = :topright,
    linewidth = 2,
)

plot!(
    df_base_with_tr.lambda, df_base_with_tr.V14_pu,
    label    = "Base, no cap, Line 2–4 tripped",
    linewidth = 2,
)

plot!(
    df_cap_with.lambda, df_cap_with.V14_pu,
    label    = "With cap, no outage",
    linewidth = 2,
)

plot!(
    df_cap_with_tr.lambda, df_cap_with_tr.V14_pu,
    label    = "With cap, Line 2–4 tripped",
    linewidth = 2,
)
