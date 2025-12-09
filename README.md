# IEEE-14_Sienna_Analysis
This repository contains Julia code and data for a complete IEEE-14 system study using PowerSystems.jl and PowerFlows.jl. It includes:

IEEE_14_Network_base_case.jl – Builds the full IEEE-14 network, applies optional shunt compensation, toggles Q-limits, and runs AC power flow.

PV_curve.jl – Performs the loadability (λ) scan, computes PV curves at Bus 14, and exports results.

CSV outputs – Voltage profiles and λ–V₁₄ curves for base, capacitor, no-limits, and Line 2-4 outage scenarios.

The project covers steady-state behavior, load-increase effects, reactive-power limits, shunt-capacitor evaluation, short-circuit results, and voltage-stability margins.
