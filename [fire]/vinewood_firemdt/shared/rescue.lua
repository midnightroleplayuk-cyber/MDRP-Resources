-- Vehicle rescue sheets (like a Crash Recovery System lookup), keyed by spawn name in lowercase.
-- Unknown models fall back to RescueClassDefaults by GTA vehicle class.
-- fuel: Petrol | Diesel | Hybrid | Electric | Hydrogen
-- All fields optional.

RescueData = {
    ['voltic']  = { fuel = 'Electric', battery = 'High-voltage pack under floor, 12V under bonnet', airbags = 'Front, side curtain', cutZones = 'Avoid sills (HV cables run along both sides)', notes = 'Isolate: ignition off, disconnect 12V, wait 5 minutes for HV capacitors.' },
    ['raiden']  = { fuel = 'Electric', battery = 'HV pack under floor', airbags = 'Front, side, curtain, knee', cutZones = 'B-pillar reinforced (boron steel)', notes = 'Do not cut orange cabling. Monitor pack with TIC for thermal runaway.' },
    ['neon']    = { fuel = 'Electric', battery = 'HV pack under floor', airbags = 'Front, side, curtain', cutZones = 'Avoid sills and roof rails', notes = 'Isolate 12V in boot well.' },
    ['cyclone'] = { fuel = 'Electric', battery = 'HV pack behind seats', airbags = 'Front', cutZones = 'Carbon tub - limited cutting, use glass management', notes = 'Low vehicle, consider dash roll.' },
    ['dilettante'] = { fuel = 'Hybrid', battery = 'HV pack under rear seat, 12V in boot', airbags = 'Front, side curtain', cutZones = 'Avoid rear seat base', notes = 'Car may be "ready" and silent — chock wheels and remove key.' },
    ['police']  = { fuel = 'Petrol', battery = '12V under bonnet', airbags = 'Front, side', cutZones = 'Standard', notes = 'Equipment loads in boot. Check for weapons locker.' },
    ['ambulance'] = { fuel = 'Diesel', battery = '12V under cab seat, auxiliary in rear', airbags = 'Front', cutZones = 'Patient compartment has oxygen cylinders', notes = 'Isolate oxygen supply in rear.' },
}

-- Fallback by GTA vehicle class (GetVehicleClass)
RescueClassDefaults = {
    [0]  = { label = 'Compact',     notes = 'Unibody. Expect boron steel B-pillars on newer vehicles.' },
    [1]  = { label = 'Saloon',      notes = 'Standard roof removal / side removal options.' },
    [2]  = { label = 'SUV',         notes = 'Higher roof line, consider stabilisation height. Heavier vehicle.' },
    [3]  = { label = 'Coupe',       notes = 'Long doors, limited rear access. Consider B-pillar rip.' },
    [4]  = { label = 'Muscle',      notes = 'Older construction, generally easier cutting.' },
    [5]  = { label = 'Sports classic', notes = 'Older construction. Possible carburettor fuel leaks.' },
    [6]  = { label = 'Sports',      notes = 'Reinforced A/B pillars. Carbon components possible.' },
    [7]  = { label = 'Super',       notes = 'Carbon tub likely — limited cutting. Possible HV systems on hybrids.' },
    [8]  = { label = 'Motorcycle',  notes = 'Casualty care priority. Check for fuel leak and hot exhaust.' },
    [9]  = { label = 'Off-road',    notes = 'Roll cages / bull bars possible. Unstable on uneven ground.' },
    [10] = { label = 'Industrial',  notes = 'Heavy plant. Hydraulic stored energy — lower all implements.' },
    [11] = { label = 'Utility',     notes = 'Check load and any gas cylinders carried.' },
    [12] = { label = 'Van',         notes = 'Check load. Possible LPG conversions.' },
    [13] = { label = 'Cycle',       notes = 'Casualty care.' },
    [14] = { label = 'Boat',        notes = 'Water rescue procedures apply.' },
    [15] = { label = 'Helicopter',  notes = 'Aircraft procedures. Rotor and fuel hazards.' },
    [16] = { label = 'Plane',       notes = 'Aircraft procedures. Large fuel loads.' },
    [17] = { label = 'Service',     notes = 'PSV - multiple casualties possible.' },
    [18] = { label = 'Emergency',   notes = 'Possible oxygen cylinders, weapons, equipment loads.' },
    [19] = { label = 'Military',    notes = 'Possible munitions — establish cordon and request specialist advice.' },
    [20] = { label = 'Commercial',  notes = 'HGV — check placards for HazMat (EAC / UN number). Cab tilt hazards.' },
    [21] = { label = 'Train',       notes = 'Rail procedures, confirm power isolation.' },
    [22] = { label = 'Open wheel',  notes = 'Low chassis, survival cell — limited cutting.' },
}
