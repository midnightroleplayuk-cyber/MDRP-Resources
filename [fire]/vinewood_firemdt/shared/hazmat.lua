-- Hazardous materials library shown on the MDT's HazMat tab.
-- This is ROLEPLAY data modelled on the layout of a Chemdata-style lookup. It is not the
-- NCEC Chemdata database and must not be used for real-world emergency response.
-- Add your own entries freely; every field except un/name is optional.
--
-- eac  = Emergency Action Code (Hazchem) shown on UK vehicle plates
-- class = ADR hazard class

Hazmat = {
    {
        un = '1203', name = 'Petrol (motor spirit)', class = '3 - Flammable liquid', eac = '3YE',
        hazards = 'Highly flammable liquid and vapour. Vapour heavier than air, travels to ignition sources. Runoff to drains creates explosion risk.',
        ppe = 'Structural fire kit with BA.',
        actions = 'Eliminate ignition sources. Prevent entry to drains and watercourses. Contain with sand/earth or booms. Foam blanket on spills.',
        fire = 'Foam. Water spray to cool containers only — water jets spread burning liquid.',
    },
    {
        un = '1202', name = 'Diesel fuel / gas oil', class = '3 - Flammable liquid', eac = '3Z',
        hazards = 'Combustible liquid. Slippery on road surfaces. Environmental pollutant.',
        ppe = 'Structural fire kit. Chemical gloves when handling.',
        actions = 'Contain spill, protect drains. Apply absorbent granules. Notify environment agency for large spills.',
        fire = 'Foam, dry powder. Water spray for cooling.',
    },
    {
        un = '1965', name = 'LPG (hydrocarbon gas mixture, liquefied)', class = '2.1 - Flammable gas', eac = '2YE',
        hazards = 'Extremely flammable gas heavier than air. Cylinders exposed to fire may BLEVE.',
        ppe = 'Structural fire kit with BA.',
        actions = 'Establish a hazard zone (consider 200m for involved cylinders). Isolate supply if safe. Cool cylinders from a protected position. Do not move hot cylinders.',
        fire = 'Stop the leak before extinguishing a gas fire. Large volumes of water spray to cool.',
    },
    {
        un = '1978', name = 'Propane', class = '2.1 - Flammable gas', eac = '2YE',
        hazards = 'Extremely flammable gas. Cylinder rupture risk when heated.',
        ppe = 'Structural fire kit with BA.',
        actions = 'Hazard zone, cooling from cover, isolate at valve if safe.',
        fire = 'Do not extinguish unless the leak can be stopped.',
    },
    {
        un = '1001', name = 'Acetylene, dissolved', class = '2.1 - Flammable gas', eac = '2SE',
        hazards = 'Cylinders heated by fire can decompose and explode some time after the fire is out.',
        ppe = 'Structural fire kit with BA.',
        actions = 'Follow acetylene cylinder procedure: hazard zone, cool, monitor with thermal imaging camera until cylinder stays cool.',
        fire = 'Water spray to cool from a protected position.',
    },
    {
        un = '1072', name = 'Oxygen, compressed', class = '2.2 - Non-flammable gas (oxidiser)', eac = '2S',
        hazards = 'Strong oxidiser. Greatly intensifies combustion. Oil and grease on fittings can ignite.',
        ppe = 'Structural fire kit.',
        actions = 'Isolate supply if safe. Keep combustibles clear. Ventilate.',
        fire = 'Water spray to cool cylinders.',
    },
    {
        un = '1017', name = 'Chlorine', class = '2.3 - Toxic gas', eac = '2XE',
        hazards = 'Toxic and corrosive gas, heavier than air. Severe respiratory irritant.',
        ppe = 'Gas-tight chemical protective suits with BA.',
        actions = 'Evacuate or shelter downwind. Approach from upwind. Water spray to knock down vapour — never put water on the leak itself.',
        fire = 'Non-flammable but supports combustion of some materials.',
    },
    {
        un = '1005', name = 'Ammonia, anhydrous', class = '2.3 - Toxic gas', eac = '2RE',
        hazards = 'Toxic and corrosive gas. Can be flammable in confined spaces.',
        ppe = 'Gas-tight chemical protective suits with BA.',
        actions = 'Evacuate downwind. Water spray to absorb vapour. Contain runoff.',
        fire = 'Water spray, dry powder.',
    },
    {
        un = '1830', name = 'Sulphuric acid', class = '8 - Corrosive', eac = '2P',
        hazards = 'Strongly corrosive. Reacts violently with water, releasing heat.',
        ppe = 'Liquid-tight chemical protective suits with BA.',
        actions = 'Contain with inert absorbent. Do not add water to the acid. Decontaminate casualties with copious water.',
        fire = 'Non-combustible. Use agent suited to surrounding fire; avoid water on the acid.',
    },
    {
        un = '1789', name = 'Hydrochloric acid', class = '8 - Corrosive', eac = '2R',
        hazards = 'Corrosive liquid giving off irritating fumes.',
        ppe = 'Liquid-tight chemical protective suits with BA.',
        actions = 'Contain, dilute only under advice, protect drains.',
        fire = 'Non-combustible.',
    },
    {
        un = '1824', name = 'Sodium hydroxide solution', class = '8 - Corrosive', eac = '2R',
        hazards = 'Corrosive alkali. Severe burns to skin and eyes.',
        ppe = 'Liquid-tight chemical protective suits.',
        actions = 'Contain, protect drains, decontaminate with water.',
        fire = 'Non-combustible.',
    },
    {
        un = '1230', name = 'Methanol', class = '3 - Flammable liquid (toxic)', eac = '2PE',
        hazards = 'Flammable, burns with an almost invisible flame. Toxic by all routes.',
        ppe = 'Structural fire kit with BA. Chemical gloves.',
        actions = 'Use thermal imaging to locate flame. Alcohol-resistant foam. Contain runoff.',
        fire = 'Alcohol-resistant foam, water spray to dilute.',
    },
    {
        un = '3480', name = 'Lithium-ion batteries', class = '9 - Miscellaneous', eac = '',
        hazards = 'Thermal runaway, re-ignition hours later, toxic and flammable off-gassing (hydrogen fluoride).',
        ppe = 'Structural fire kit with BA.',
        actions = 'Large volumes of water to cool. Monitor with thermal imaging camera. Consider immersion for small packs.',
        fire = 'Copious water for cooling. Expect re-ignition.',
    },
}
