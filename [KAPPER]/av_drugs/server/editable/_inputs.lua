-- I don't want to make the _tables file too big or it will become really hard to edit...
-- Make sure to match a key index from this list with the itemName from _tables/_labs.lua

--[[
    How it works:
    - Each input contributes a value that gets added up when the purity is calculated (check server/editable/purity.lua).
    - These inputs affect the total sum that influences the purity of the drug.
    - The better the input values, the higher the purity will be when calculated with the player/lab XP.
    - Make sure the sum of all maximum input values doesn't exceed 10.
    
    About sliders in UI:
    
    - The slider uses the convertToPercentage function to simplify the user experience by hiding the actual min and max values. 
      Instead of showing the real range (e.g., -10 to 0 for temperature), the slider is presented as a clean 0% to 100% scale.
    - If the player sets all sliders to 100%, the output value will be replaced with the minimum to trick the player and encourage them to try different combinations.

    This means:

    The min value becomes 0%, and the max value becomes 100%.
    The user only interacts with the slider as if it's a standard percentage scale, making it easier to adjust inputs without worrying about the underlying technical values.
    Behind the scenes, the chosen value is converted back to the actual range, but the user just sees a simple percentage slider.
    This helps keep the interface intuitive and straightforward, without exposing the complex input ranges.
]]--

Config = Config or {}

lib.callback.register('av_drugs:getInput', function(source,type)
    local drug = Config.Tables[type] and Config.Tables[type]['drug']
    return Config.Inputs and Config.Inputs[drug] or false
end)

Config.Inputs = {
    ['moonshine'] = { -- drug name
        title = "Brew Moonshine",
        description = "Combine ingredients at optimal temperature, then mix with water and yeast to start the fermentation process for brewing moonshine.",
        inputs = {
            {
                key = "temperature", -- an unique key
                label = "Temperature", -- label for this slider
                description = "Controls the fermentation and distillation environment", -- short description
                min = -10, -- min value (can be positive or negative)
                max = 0, -- max value (can be positive or negative, just make sure is higher than min value)
                color = "orange.2", -- slider color https://mantine.dev/theming/colors/#default-colors or hex/rgb
            },
            {
                key = "water",
                label = "Water",
                description = "Necessary for mixing and diluting the final product",
                min = 0,
                max = 4,
                color = "cyan.2",
            },
            {
                key = "yeast",
                label = "Yeast",
                description = "Converts sugars into alcohol and carbon dioxide during fermentation",
                min = 0,
                max = 5,
                color = "violet.2",
            },
        }
    },
    ['fentanyl'] = {
        title = "Fentanyl Cooking",
        description = "Mix precursor chemicals, control temperature, and balance pH to get the perfect cook.",
        inputs = {
            {
                key = "chemicals", -- an unique key
                label = "Chemicals", -- label for this slider
                description = "Adjust the mix of chemicals to hit the sweet spot for synthesis.", -- short description
                min = -9, -- min value (can be positive or negative)
                max = 1, -- max value (can be positive or negative, just make sure is higher than min value)
                color = "violet.2", -- slider color https://mantine.dev/theming/colors/#default-colors or hex/rgb
            },
            {
                key = "temperature",
                label = "Temperature",
                description = " Keep the temperature just right. Too hot or too cold, and you'll ruin the brew.",
                min = -5,
                max = 5,
                color = "orange.2",
            },
            {
                key = "ph",
                label = "pH Balance",
                description = "Think of it like mixing the ultimate potion - get it wrong, and it's game over!",
                min = -7,
                max = 3,
                color = "cyan.2",
            },
        }
    },
    ['heroin'] = {
        title = "Heroin Refining",
        description = "Carefully control the mixture, heat, and chemical reactions.",
        inputs = {
            {
                key = "acetic_anhydride", -- unique key
                label = "Acetic Anhydride", -- label for this slider
                description = "Adjust the amount of acetic anhydride for the acetylation process.", -- short description
                min = -8, -- minimum value
                max = 2, -- maximum value
                color = "yellow.2", -- slider color
            },
            {
                key = "morphine_base",
                label = "Morphine Base",
                description = "Balance the morphine base to get the best quality yield.",
                min = -10,
                max = 0,
                color = "teal.2",
            },
            {
                key = "catalyst_ratio",
                label = "Catalyst Ratio",
                description = "Perfectly balance the catalyst to speed up the reaction.",
                min = -5,
                max = 5,
                color = "pink.2",
            },
            {
                key = "reaction_time",
                label = "Reaction Time",
                description = "Control the reaction time to ensure the batch doesn't overcook or undercook.",
                min = -9,
                max = 1,
                color = "cyan.2",
            },
        }
    },
    ['ketamine'] = {
        title = "Ketamine Synthesis",
        description = "Carefully manage the chemical reactions and conditions to synthesize high-quality ketamine.",
        inputs = {
            {
                key = "cyclohexanone", -- unique key
                label = "Cyclohexanone", -- label for this slider
                description = "Adjust the amount of cyclohexanone, the key starting material for the synthesis.", -- short description
                min = -10, -- minimum value
                max = 0, -- maximum value
                color = "blue.2", -- slider color
            },
            {
                key = "methylamine",
                label = "Methylamine",
                description = "Control the methylamine level to ensure proper reaction with the ketone group.",
                min = -7,
                max = 3,
                color = "green.2",
            },
            {
                key = "hydrochloric_acid",
                label = "Hydrochloric Acid",
                description = "Balance the concentration of hydrochloric acid for purification during the synthesis.",
                min = -5,
                max = 5,
                color = "red.2",
            },
            {
                key = "temperature_control",
                label = "Temperature Control",
                description = "Maintain an optimal temperature to ensure the reaction occurs efficiently and safely.",
                min = -8,
                max = 2,
                color = "orange.2",
            },
        }
    },
    ['meth'] = {
        title = "Meth Synthesis",
        description = "Control the chemical process to create potent meth.",
        inputs = {
            {
                key = "pseudoephedrine",
                label = "Pseudoephedrine",
                description = "Adjust the amount of pseudoephedrine, the essential precursor for meth production.",
                min = -10,
                max = 0,
                color = "blue.2",
            },
            {
                key = "anhydrous_ammonia",
                label = "Anhydrous Ammonia",
                description = "Regulate the amount of anhydrous ammonia to catalyze the reaction.",
                min = -5,
                max = 5,
                color = "cyan.2",
            },
            {
                key = "red_phosphorus",
                label = "Red Phosphorus",
                description = "Monitor the red phosphorus levels for the reduction of ephedrine into meth.",
                min = -9,
                max = 1,
                color = "red.2",
            },
            {
                key = "temperature_control",
                label = "Temperature Control",
                description = "Maintain precise temperature to prevent overheating, ensuring a safe and productive synthesis.",
                min = -7,
                max = 3,
                color = "orange.2",
            },
        }
    },
    ['coke'] = {
        title = "Cocaine Refinement",
        description = "Master the delicate balance of chemicals and processes to maximize quality.",
        inputs = {
            {
                key = "sulfuric_acid",
                label = "Sulfuric Acid",
                description = "Use sulfuric acid to create a paste by breaking down the alkaloids in the coca leaves.",
                min = -8,
                max = 2,
                color = "yellow.2",
            },
            {
                key = "kerosene",
                label = "Kerosene",
                description = "Add kerosene to separate the cocaine alkaloids from the rest of the leaf matter.",
                min = -10,
                max = 0,
                color = "blue.2",
            },
            {
                key = "sodium_bicarbonate",
                label = "Sodium Bicarbonate",
                description = "Neutralize acids and solidify the cocaine paste.",
                min = -5,
                max = 5,
                color = "gray.2",
            },
            {
                key = "temperature_control",
                label = "Temperature Control",
                description = "Maintain precise heat levels to ensure proper extraction and crystallization.",
                min = -7,
                max = 3,
                color = "orange.2",
            },
        }
    },
    ['lsd'] = {
        title = "LSD Synthesis",
        description = "Synthesize LSD by carefully managing the precursor chemicals and reaction conditions.",
        inputs = {
            {
                key = "lysergic_acid",
                label = "Lysergic Acid",
                description = "The key precursor derived from ergot alkaloids.",
                min = -6,
                max = 4,
                color = "violet.3",
            },
            {
                key = "diethylamine",
                label = "Diethylamine",
                description = "React lysergic acid with diethylamine to form the LSD compound.",
                min = -8,
                max = 2,
                color = "blue.2",
            },
            {
                key = "solvent_selection",
                label = "Solvent Selection",
                description = "Choose the right solvent for dissolving the reagents and ensuring a successful reaction.",
                min = -9,
                max = 1,
                color = "green.2",
            },
            {
                key = "temperature_control",
                label = "Temperature Control",
                description = "Monitor the temperature closely to ensure the reaction proceeds without degrading the final product.",
                min = -7,
                max = 3,
                color = "red.3",
            },
        }
    },
}