## IEEE-14_Sienna_Analysis
Steady-state, short-circuit, and voltage-stability analysis of the IEEE-14 system using PowerSystems.jl and PowerFlows.jl. Includes load-increase studies, reactive-power limits, shunt compensation, breaker sizing, and CPF PV-curve analysis.
# IEEE_14_Network_base_case.jl:
Complete construction of the IEEE-14 system:
Bus, line, transformer, generator, load, and condenser definitions
Optional shunt-capacitor injection
Option to toggle reactive-power limits
Runs AC power flow and prints system-wide results
# PV_curve.jl
Runs the custom CPF-like loadability scan:
Scales all system loads by λ
Solves AC power flow for each λ
Records |V₁₄| to build PV curves
Exports results as CSV and plots the PV curve
# CSV Output Files
Each CSV corresponds to one simulation scenario. Examples:
Base_case_with_limits.csv – Base case, reactive limits enforced
Base_case_without_limits.csv – Base case, no Q limits
Cap_case_with_limits.csv – Capacitor case
*_tripped.csv – Line 2-4 outage scenarios
*_test.csv – Higher-resolution PV curve samples
These files store the voltages or λ–V₁₄ profiles used for plotting and comparison.
