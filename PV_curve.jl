using PowerSystems
using PowerFlows
using DataFrames, CSV, Plots
# ===============Definition of the base power================

IEEE_14=System(100)

# ===============Definition of the buses=================

# Function to define buses

const SLACK=ACBusTypes.SLACK
const PV=ACBusTypes.PV
const PQ=ACBusTypes.PQ

function buses(sys,number, name,bustype,magnitude,base_voltage)
    bus=ACBus(;
        number=number,
        name=name,
        available=true,
        bustype=bustype,
        angle=0,
        magnitude=magnitude,
        voltage_limits=(min=0.9,max=1.1),
        base_voltage=base_voltage,
    );
    add_component!(sys,bus)
    return bus
end

Bus1=buses(IEEE_14,1,"Bus1",SLACK,1.06,69)
Bus2=buses(IEEE_14,2,"Bus2",PV,1.045,69)
Bus3=buses(IEEE_14,3,"Bus3",PV,1.01,69)
Bus4=buses(IEEE_14,4,"Bus4",PQ,1.0,69)
Bus5=buses(IEEE_14,5,"Bus5",PQ,1.0,69)
Bus6=buses(IEEE_14,6,"Bus6",PV,1.07,13.8)
Bus7=buses(IEEE_14,7,"Bus7",PQ,1.0,13.8)
Bus8=buses(IEEE_14,8,"Bus8",PV,1.09,18)
Bus9=buses(IEEE_14,9,"Bus9",PQ,1.0,13.8)
Bus10=buses(IEEE_14,10,"Bus10",PQ,1.0,13.8)
Bus11=buses(IEEE_14,11,"Bus11",PQ,1.0,13.8)
Bus12=buses(IEEE_14,12,"Bus12",PQ,1.0,13.8)
Bus13=buses(IEEE_14,13,"Bus13",PQ,1.0,13.8)
Bus14=buses(IEEE_14,14,"Bus14",PQ,1.0,13.8)

# ===============Definition of the lines=================

#Funtion to define Lines

# The line rating is expressed in per-unit on a 100 MVA system base. Since PowerSystems
# suggested a typical range of 12–115 MVA for lines at these voltage levels, we choose
# rating = 1.05 pu (≈105 MVA) to stay near the upper end of the expected range, as no
# line ratings are provided in the project data.
#
# The angle_limits values are taken from the default Sienna/PowerSystems examples for
# steady-state and CPF stability studies. The project does not provide explicit angle
# limits, so we adopt these example values to complete the Line data model.

function lines(sys,name,from,to,r,x,b)
    line=Line(;
        name=name,
        available=true,
        active_power_flow=0.0,
        reactive_power_flow=0.0,
        arc=Arc(;from=from,to=to),
        r=r,
        x=x,
        b=(from=b/2, to=b/2),
        rating=1.05,
        angle_limits = (min = -0.7, max = 0.7),
    );
    add_component!(sys,line)
    return line
end
Line_2_5=lines(IEEE_14,"Line_2_5",Bus2,Bus5,0.05695,0.17388,0.034)
Line_6_12=lines(IEEE_14,"Line_6_12",Bus6,Bus12,0.12291,0.25581,0.0)
Line_12_13=lines(IEEE_14,"Line_12_13",Bus12,Bus13,0.22092,0.19988,0.0)
Line_6_13=lines(IEEE_14,"Line_6_13",Bus6,Bus13,0.06615,0.13027,0.0)
Line_6_11=lines(IEEE_14,"Line_6_11",Bus6,Bus11,0.09498,0.1989,0.0)
Line_11_10 = lines(IEEE_14,"Line_11_10", Bus11,Bus10, 0.08205, 0.19207, 0.0)
Line_9_10  = lines(IEEE_14,"Line_9_10",  Bus9, Bus10, 0.03181, 0.08450, 0.0)
Line_9_14  = lines(IEEE_14,"Line_9_14",  Bus9, Bus14, 0.12711, 0.27038, 0.0)
Line_14_13 = lines(IEEE_14,"Line_14_13", Bus14,Bus13, 0.17093, 0.34802, 0.0)
Line_7_9   = lines(IEEE_14,"Line_7_9",   Bus7, Bus9,  0.0,     0.11001, 0.0)
Line_1_2   = lines(IEEE_14,"Line_1_2",   Bus1, Bus2,  0.01938, 0.05917, 0.0528)
Line_3_2   = lines(IEEE_14,"Line_3_2",   Bus3, Bus2,  0.04699, 0.19797, 0.0438)
Line_3_4   = lines(IEEE_14,"Line_3_4",   Bus3, Bus4,  0.06701, 0.17103, 0.0346)
Line_1_5   = lines(IEEE_14,"Line_1_5",   Bus1, Bus5,  0.05403, 0.22304, 0.0492)
Line_5_4   = lines(IEEE_14,"Line_5_4",   Bus5, Bus4,  0.01335, 0.04211, 0.0128)
#Line_2_4   = lines(IEEE_14,"Line_2_4",   Bus2, Bus4,  0.05811, 0.17632, 0.0374)
# ================Definition of the Loads=================

# Function to define Loads

function loads(sys,name,bus,pl,ql)
    load=PowerLoad(;
        name=name,
        available=true,
        bus=bus,
        active_power=pl/100.0*1,
        reactive_power=ql/100.0*1,
        base_power=100.0,
        max_active_power=pl/100.0*1,
        max_reactive_power=ql/100.0*1,
    );
    add_component!(sys,load)
    return load
end
Load_2=loads(IEEE_14,"Load_2",Bus2,21.7,12.7)
Load_3=loads(IEEE_14,"Load_3",Bus3,94.2,19)
Load_4=loads(IEEE_14,"Load_4",Bus4,47.8,0)
Load_5=loads(IEEE_14,"Load_5",Bus5,7.6,1.6)
Load_6=loads(IEEE_14,"Load_6",Bus6,11.2,7.5)
Load_9=loads(IEEE_14,"Load_9",Bus9,29.5,16.6)
Load_10=loads(IEEE_14,"Load_10",Bus10,9,5.8)
Load_11=loads(IEEE_14,"Load_11",Bus11,3.5,1.8)
Load_12=loads(IEEE_14,"Load_12",Bus12,6.1,1.6)
Load_13=loads(IEEE_14,"Load_13",Bus13,13.5,5.8)
Load_14=loads(IEEE_14,"Load_14",Bus14,14.9,5.0)

# ================Definition of the Generators=================

# Function to define Generators

function generators(sys,name,bus,pg,qmax,qmin,MVA_base)
    gen=ThermalStandard(;
        name=name,
        available=true,
        status=true,
        bus=bus,
        active_power=pg/MVA_base,
        reactive_power=0.0, #initial guess
        rating=1.0, #generator can utilize 100% of its own base power
        active_power_limits=(min=0.0,max=pg*2/MVA_base), # Table 1 does not include Pmin or Pmax. We choose a simple feasible range from 0 up to the scheduled 2 times PG in the base case
        reactive_power_limits=(min=qmin/MVA_base,max=qmax/MVA_base),
        ramp_limits=(up=0.0,down=0.0), # Ramp data (MW/min) is not provided and is not used by ACPowerFlow/CPF, using 0.0 is a neutral placeholder.
        operation_cost=ThermalGenerationCost(nothing),
        base_power=MVA_base,
        must_run=true,
    );
    add_component!(sys,gen)
    return gen
end

Gen_1=generators(IEEE_14,"Gen_1",Bus1,232,1000,-1000,615)
Gen_2=generators(IEEE_14,"Gen_2",Bus2,40,50,-40,69)

# ================Definition of the Synchronous Condensers=================

# Function to define Synchronous Condensers

function condensers(sys,name,bus,qgmax,qgmin,MVA_base)
    sc=SynchronousCondenser(;
        name=name,
        available=true,
        bus=bus,
        reactive_power=0.0, #initial guess
        rating=1.0, #Synchronous condenser can utilize 100% of its own base power
        reactive_power_limits=(min=qgmin/MVA_base,max=qgmax/MVA_base),
        base_power=MVA_base,
    );
    add_component!(sys,sc)
    return sc
end

SC_3=condensers(IEEE_14,"SC_3",Bus3,40, 0, 69)
SC_6=condensers(IEEE_14,"SC_6",Bus6,24, -6, 18)
SC_8=condensers(IEEE_14,"SC_8",Bus8,24, -6, 18)

# ==================Definition of the Transformers=================

# Function to define Two-winding transformers

function Transformer(sys,name,from,to,r,x,a)
    transformer=TapTransformer(;
        name=name,
        available=true,
        active_power_flow = 0.0, # Initial guess
        reactive_power_flow = 0.0, # Initial guess
        arc=Arc(;from=from,to=to),
        r=r,
        x=x,
        primary_shunt = 0.0, # Not provided in the data
        tap=a,
        rating=1.0, # Transformer can utilize 100% of its own base power
        base_power=100.0,
        
    );
    add_component!(sys,transformer)
    return transformer
end

XFMER_5_6=Transformer(IEEE_14,"XFMER_5_6",Bus5,Bus6,0.0,0.25202,0.932)
XFMER_4_9=Transformer(IEEE_14,"XFMER_4_9",Bus4,Bus9,0.0,0.55618,0.969)
XFMER_4_7=Transformer(IEEE_14,"XFMER_4_7",Bus4,Bus7,0.0,0.20912,0.978)
XFMER_8_7=Transformer(IEEE_14,"XFMER_8_7",Bus8,Bus7,0.0,0.17615,1.0)

# Note for three winding transformers:
# Although the system contains a physical three-winding transformer, 
# the project data provide only its positive-sequence network equivalent (the 4–7, 4–9, and 7–9 branches). 
# For PowerFlows and CPF this equivalent is exactly what PowerSystems expects, 
# so modeling the device as separate two-winding branches preserves the correct Ybus without 
# requiring unavailable transformer parameters.

#Adding Shunt Capacitor 

function add_shunt_capacitor!(sys,name, bus, Q_Mvar)         
    # S = P + jQ  ~  |V|^2 * conj(Y)
    # Para Q > 0 (inyección), se requiere Im(Y) < 0  => Y = -j * Q_pu
    cap = FixedAdmittance(
        name      = name,
        available = true,
        bus       = bus,
        Y         = 0.0 + im * Q_Mvar / 100,
    )

    add_component!(sys, cap)
    return cap
end

Capacitor_14=add_shunt_capacitor!(IEEE_14,"Capacitor_14",Bus14,0)
Capacitor_13=add_shunt_capacitor!(IEEE_14,"Capacitor_13",Bus13,0)

# ================== CPF-STYLE LOADABILITY SCAN (ALL LOADS) ==================
function scan_loadability(; λ_start = 0.0,
                                 λ_step  = 0.1,      # initial step size
                                 λ_max   = 5.65,
                                 change_factor = 0.01,
                                 enforce_limits = true)

    println("\n================ LOADABILITY SCAN (CPF-style, all loads) ================")

    # Base system 
    base_sys = IEEE_14

    # Store ALL base loads (P and Q) 
    base_loads = collect(get_components(PowerLoad, base_sys))
    base_p = [get_active_power(l) for l in base_loads]
    base_q = [get_reactive_power(l) for l in base_loads]

    # Solver and refinement parameters
    pf = ACPowerFlow()
    step_size = λ_step
    λ_init = λ_start

    # Arrays to store the PV curve
    lambdas = Float64[]
    v_bus14 = Float64[]

    while step_size > 1e-5 && λ_init < λ_max
        println("\n--- New refinement loop: step_size = ", step_size,
                ", starting from λ_init = ", λ_init, " ---")

        # Sweep λ with the current step size
        for λ in λ_init:step_size:λ_max
            println("  Testing λ = ", λ)

            # Create a fresh system copy (RESET at each λ)
            sys = deepcopy(base_sys)

            # Obtain ALL loads in this system and scale them
            loads = collect(get_components(PowerLoad, sys))

            for (i, load) in enumerate(loads)
                set_active_power!(load,  base_p[i] * λ)
                set_reactive_power!(load, base_q[i] * λ)

                # Avoid max_* limiting the scaling
                set_max_active_power!(load,  10.0)
                set_max_reactive_power!(load, 10.0)
            end

            # Solve the power flow
            res = false
            try
                res = solve_powerflow!(pf, sys; check_reactive_power_limits = enforce_limits)
            catch e
                println("    → Did NOT converge for λ = ", λ)
                println("       Error: ", e)
                break
            end

            # If solver returns false, stop scanning
            if res == false
                println("    → Did NOT converge (solver returned false) for λ = ", λ)
                break
            end

            println("    → Converged at λ = ", λ)

            # Record |V| at Bus 14
            buses = collect(get_components(ACBus, sys))
            bus14 = first(b for b in buses if get_number(b) == 14)
            v14   = get_magnitude(bus14)

            push!(lambdas, λ)
            push!(v_bus14, v14)
        end

        # If no convergent points exist, stop CPF
        if isempty(lambdas)
            println("No convergent point found — stopping CPF loop.")
            break
        end

        # Refine step size and restart from the last convergent λ
        step_size *= change_factor
        λ_init = last(lambdas)
    end

    max_λ_reached = isempty(lambdas) ? λ_start : last(lambdas)

    println("\n*** Maximum convergent λ (CPF-style, all loads) = ", max_λ_reached, " ***")
    println("=====================================================================\n")

    return max_λ_reached, lambdas, v_bus14
end

max_lambda_reached, lambdas, v_bus14 = scan_loadability()

CASE_NAME = "Base_case_with_limits_tripped_test"  

results_df = DataFrame(lambda = lambdas, V14_pu = v_bus14)
csv_filename = CASE_NAME * ".csv"
CSV.write(csv_filename, results_df)
df_plot = CSV.read(csv_filename, DataFrame)
Plots.plot(df_plot.lambda, df_plot.V14_pu,
     xlabel = "λ",
     ylabel = "|V₁₄| (p.u.)",
     title  = "Bus 14 Voltage vs Load Factor λ - " * CASE_NAME,
     legend = false)
