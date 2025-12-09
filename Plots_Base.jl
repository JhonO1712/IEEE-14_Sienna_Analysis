using CSV
using DataFrames
using Plots

# === Read all four cases ===
df_base_with      = CSV.read("Base_case_with_limits_test.csv", DataFrame)
df_base_without   = CSV.read("Base_case_without_limits_test.csv", DataFrame)
df_trip_with      = CSV.read("Base_case_with_limits_tripped_test.csv", DataFrame)
df_trip_without   = CSV.read("Base_case_without_limits_tripped_test.csv", DataFrame)

# === Single plot with all PV curves at Bus 14 ===
plot(
    df_base_with.lambda, df_base_with.V14_pu,
    label  = "Base - with Q limits",
    xlabel = "λ",
    ylabel = "|V₁₄| (p.u.)",
   
    legend = :topright,
)

plot!(
    df_base_without.lambda, df_base_without.V14_pu,
    label = "Base - without Q limits",
)

plot!(
    df_trip_with.lambda, df_trip_with.V14_pu,
    label = "Line 2-4 tripped - with Q limits",
)

plot!(
    df_trip_without.lambda, df_trip_without.V14_pu,
    label = "Line 2-4 tripped - without Q limits",
)

