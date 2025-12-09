using CSV
using DataFrames
using Plots
# === Read the four capacitor-case scenarios ===
df_cap_with        = CSV.read("Cap_case_with_limits.csv", DataFrame)
df_cap_without     = CSV.read("Cap_case_without_limits.csv", DataFrame)
df_cap_tr_with     = CSV.read("Cap_case_with_limits_tripped.csv", DataFrame)
df_cap_tr_without  = CSV.read("Cap_case_without_limits_tripped.csv", DataFrame)
# === Single PV plot with all four capacitor-case curves ===
plot(
    df_cap_with.lambda, df_cap_with.V14_pu,
    label  = "Capacitor - with Q limits",
    xlabel = "λ",
    ylabel = "|V₁₄| (p.u.)",
    legend = :topright,
    linewidth = 2,
)

plot!(
    df_cap_without.lambda, df_cap_without.V14_pu,
    label = "Capacitor - without Q limits",
    linewidth = 2,
)

plot!(
    df_cap_tr_with.lambda, df_cap_tr_with.V14_pu,
    label = "Capacitor + Line 2-4 tripped - with Q limits",
    linewidth = 2,
)

plot!(
    df_cap_tr_without.lambda, df_cap_tr_without.V14_pu,
    label = "Capacitor + Line 2-4 tripped - without Q limits",
    linewidth = 2,
)