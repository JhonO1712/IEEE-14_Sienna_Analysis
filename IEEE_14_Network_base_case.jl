using PowerSystems
using PowerFlows

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
Line_2_4   = lines(IEEE_14,"Line_2_4",   Bus2, Bus4,  0.05811, 0.17632, 0.0374)

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
# ==================Model is complete=================
#Select if to enforce reactive power limits or not
ENFORCE_LIMITS=true

# =========================================================================
# Run the Power Flow with the mode selected  (True/False)
pf=ACPowerFlow()
solve_powerflow!(pf, IEEE_14; check_reactive_power_limits = ENFORCE_LIMITS)
# Get base power for unit conversion
base_power = get_base_power(IEEE_14) # 100 MVA

println("\n============================================================")
println("      IEEE 14-BUS SYSTEM RESULTS REPORT")
println("      Reactive Limits Enforced: ", ENFORCE_LIMITS ? "YES" : "NO")
println("============================================================")

# --- A. BUS REPORT (Voltage Magnitude & Angle) ---
println("\n>>> 1. BUS STATUS")
println(rpad("Bus Name", 10), rpad("Type", 8), rpad("Voltage (pu)", 14), "Angle (deg)")
println("-"^50)
# Sort buses by number for cleaner output
buses_sorted = sort!(collect(get_components(ACBus, IEEE_14)), by = x -> get_number(x))
for b in buses_sorted
    v_val = round(get_magnitude(b), digits=4)
    ang_val = round(rad2deg(get_angle(b)), digits=2)
    println(rpad(get_name(b), 10), rpad(string(get_bustype(b)), 8), rpad(v_val, 14), ang_val)
end

# --- B. GENERATOR REPORT (Active & Reactive Power) ---
println("\n>>> 2. GENERATOR OUTPUT (sorted by bus)")
println(rpad("Name", 10),
        rpad("Bus", 8),
        rpad("P (MW)", 12),
        rpad("Q (Mvar)", 12),
        "Limits [Min, Max]")

println("-"^65)

# sort generators by bus number
sorted_gens = sort!(
    collect(get_components(ThermalStandard, IEEE_14)),
    by = g -> get_number(get_bus(g))
)

for g in sorted_gens
    p_gen = round(get_active_power(g) * base_power, digits=3)
    q_gen = round(get_reactive_power(g) * base_power, digits=3)
    bus_name = get_name(get_bus(g))

    lims = get_reactive_power_limits(g)
    lim_str = "[$(round(lims.min * base_power, digits=1)), $(round(lims.max * base_power, digits=1))]"

    println(rpad(get_name(g), 10),
            rpad(bus_name, 8),
            rpad(p_gen, 12),
            rpad(q_gen, 12),
            lim_str)
end


# --- C. SYNCHRONOUS CONDENSER REPORT ---
println("\n>>> 3. SYNCHRONOUS CONDENSER OUTPUT (sorted by bus)")
println(rpad("Name", 10),
        rpad("Bus", 8),
        rpad("Q (Mvar)", 12),
        "Limits [Min, Max]")

println("-"^55)

# sort synchronous condensers by bus number
sorted_scs = sort!(
    collect(get_components(SynchronousCondenser, IEEE_14)),
    by = sc -> get_number(get_bus(sc))
)

for sc in sorted_scs
    q_sc = round(get_reactive_power(sc) * base_power, digits=3)
    bus_name = get_name(get_bus(sc))

    lims = get_reactive_power_limits(sc)
    lim_str = "[$(round(lims.min * base_power, digits=1)), $(round(lims.max * base_power, digits=1))]"

    println(rpad(get_name(sc), 10),
            rpad(bus_name, 8),
            rpad(q_sc, 12),
            lim_str)
end

# --- D. LOAD REPORT ---
println("\n>>> 4. LOAD CONSUMPTION (sorted by bus)")
println(rpad("Name", 10),
        rpad("Bus", 8),
        rpad("P (MW)", 12),
        "Q (Mvar)")

println("-"^45)

# sort loads by bus number
sorted_loads = sort!(
    collect(get_components(PowerLoad, IEEE_14)),
    by = l -> get_number(get_bus(l))
)

for l in sorted_loads
    p_load = round(get_active_power(l) * base_power, digits=3)
    q_load = round(get_reactive_power(l) * base_power, digits=3)
    bus_name = get_name(get_bus(l))

    println(rpad(get_name(l), 10),
            rpad(bus_name, 8),
            rpad(p_load, 12),
            q_load)
end


# --- E LINE FLOWS (sorted) ---
println("\n>>> 5. LINE FLOWS (From -> To)")
println(rpad("Name", 12),
        rpad("Type", 10),
        rpad("Path", 14),
        rpad("P Flow (MW)", 14),
        "Q Flow (Mvar)")
println("-"^70)

# collect and sort only LINES
line_branches = sort!(
    collect(get_components(Line, IEEE_14)),
    by = br -> begin
        arc = get_arc(br)
        (get_number(get_from(arc)), get_number(get_to(arc)))
    end
)

for br in line_branches
    p_flow = round(get_active_power_flow(br) * base_power, digits=3)
    q_flow = round(get_reactive_power_flow(br) * base_power, digits=3)

    arc = get_arc(br)
    path = "$(get_number(get_from(arc))) -> $(get_number(get_to(arc)))"

    println(rpad(get_name(br), 12),
            rpad("Line", 10),
            rpad(path, 14),
            rpad(p_flow, 14),
            q_flow)
end


# --- F TRANSFORMER FLOWS (sorted) ---
println("\n>>> 6. TRANSFORMER FLOWS (From -> To)")
println(rpad("Name", 12),
        rpad("Type", 10),
        rpad("Path", 14),
        rpad("Tap", 10),
        rpad("Prim kV", 12),
        rpad("Sec kV", 12),
        rpad("P Flow (MW)", 14),
        "Q Flow (Mvar)")
println("-"^100)

# collect and sort only TRANSFORMERS (TapTransformer)
xfmr_branches = sort!(
    collect(get_components(TapTransformer, IEEE_14)),
    by = br -> begin
        arc = get_arc(br)
        (get_number(get_from(arc)), get_number(get_to(arc)))
    end
)

for br in xfmr_branches
    p_flow = round(get_active_power_flow(br) * base_power, digits=3)
    q_flow = round(get_reactive_power_flow(br) * base_power, digits=3)
    arc = get_arc(br)
    path = "$(get_number(get_from(arc))) -> $(get_number(get_to(arc)))"
    tap = get_tap(br)
    kv_primary   = get_base_voltage(get_from(arc))
    kv_secondary = get_base_voltage(get_to(arc))

    println(rpad(get_name(br), 12),
            rpad("XFMR", 10),
            rpad(path, 14),
            rpad(round(tap; digits=4), 10),
            rpad(round(kv_primary; digits=3), 12),
            rpad(round(kv_secondary; digits=3), 12),
            rpad(p_flow, 14),
            q_flow)
end

# ================== SYSTEM SUMMARY (for comparison True / False) ==================
println("\n>>> 6. SYSTEM SUMMARY")

# Total generation and load (P and Q)
total_P_gen = sum(get_active_power(g) for g in get_components(ThermalStandard, IEEE_14)) * base_power
total_P_load = sum(get_active_power(l) for l in get_components(PowerLoad, IEEE_14)) * base_power

# Losses = Generation - Load
P_losses = total_P_gen - total_P_load


# "Efficiency" as how much of generated P actually goes to load
efficiency = total_P_gen ≈ 0 ? 0.0 : (total_P_load / total_P_gen) * 100

println("Total P generation (MW): ", round(total_P_gen, digits=3))
println("Total P load       (MW): ", round(total_P_load, digits=3))
println("Total P losses     (MW): ", round(P_losses,   digits=3))


println("System efficiency (P_load / P_gen): ", round(efficiency, digits=2), " %")

# Voltage range (good for comparing ENFORCE_LIMITS true/false)

v_pairs = [(get_name(b), get_magnitude(b)) for b in buses_sorted]

min_bus, min_v = findmin(last.(v_pairs))
max_bus, max_v = findmax(last.(v_pairs))

# findmin/findmax on just magnitudes; then map back to names
min_idx = argmin(last.(v_pairs))
max_idx = argmax(last.(v_pairs))

println("Minimum bus voltage: ",
        round(v_pairs[min_idx][2], digits=4),
        " pu at ", v_pairs[min_idx][1])

println("Maximum bus voltage: ",
        round(v_pairs[max_idx][2], digits=4),
        " pu at ", v_pairs[max_idx][1])
        
# ---- Angle range ----
ang_pairs = [(get_name(b), rad2deg(get_angle(b))) for b in buses_sorted]

min_ang_idx = argmin(last.(ang_pairs))
max_ang_idx = argmax(last.(ang_pairs))

println("Minimum bus angle: ",
        round(ang_pairs[min_ang_idx][2], digits=2),
        " deg at ", ang_pairs[min_ang_idx][1])

println("Maximum bus angle: ",
        round(ang_pairs[max_ang_idx][2], digits=2),
        " deg at ", ang_pairs[max_ang_idx][1])

println("\n============================================================")
