Config = {}

--[[
    Command to start the minigame
    Set to false to disable the command
    Set to true to enable the command
    Usage: /startCraftingMinigame [minigame] [mode]
    Example: /startCraftingMinigame circuit easy
    Available minigames: alchemy, scale, hammer, heat
--]]
    
Config.CommandEnabled = true

Config.Minigames = {
    ['alchemy'] = {
        settings = {
            ['regular'] = {
                timeLimit = 60,
                recipeLength = 8,
                ingredientCount = 16,
                ingredientLibrary = {
                    { id = 1, name = "Dragon Scale", icon = "🐉" },
                    { id = 2, name = "Phoenix Feather", icon = "🔥" },
                    { id = 3, name = "Moonstone", icon = "🌙" },
                    { id = 4, name = "Star Dust", icon = "✨" },
                    { id = 5, name = "Crystal Shard", icon = "💎" },
                    { id = 6, name = "Mystic Herb", icon = "🌿" },
                    { id = 7, name = "Demon Blood", icon = "🩸" },
                    { id = 8, name = "Angel Wing", icon = "🕊️" },
                    { id = 9, name = "Lightning Bolt", icon = "⚡" },
                    { id = 10, name = "Ice Crystal", icon = "❄️" },
                    { id = 11, name = "Fire Essence", icon = "🔥" },
                    { id = 12, name = "Earth Stone", icon = "🪨" },
                    { id = 13, name = "Water Pearl", icon = "💧" },
                    { id = 14, name = "Wind Essence", icon = "💨" },
                    { id = 15, name = "Shadow Ink", icon = "🖤" },
                    { id = 16, name = "Golden Dust", icon = "✨" },
                    { id = 17, name = "Silver Leaf", icon = "🍃" },
                    { id = 18, name = "Ruby Gem", icon = "💍" },
                    { id = 19, name = "Sapphire", icon = "💠" },
                    { id = 20, name = "Emerald", icon = "🟢" },
                    { id = 21, name = "Void Fragment", icon = "🌑" },
                    { id = 22, name = "Time Sand", icon = "⏳" },
                    { id = 23, name = "Soul Crystal", icon = "👻" },
                    { id = 24, name = "Life Bloom", icon = "🌸" },
                    { id = 25, name = "Frost Fang", icon = "🦷" },
                    { id = 26, name = "Ancient Bone", icon = "🦴" },
                    { id = 27, name = "Spider Silk", icon = "🕸️" },
                    { id = 28, name = "Venom Sac", icon = "☠️" },
                    { id = 29, name = "Unicorn Hair", icon = "🦄" },
                    { id = 30, name = "Griffin Claw", icon = "🦅" },
                    { id = 31, name = "Kraken Ink", icon = "🦑" },
                    { id = 32, name = "Basilisk Eye", icon = "👁️" },
                    { id = 33, name = "Mandrake Root", icon = "🌱" },
                    { id = 34, name = "Blood Rose", icon = "🌹" },
                    { id = 35, name = "Night Bloom", icon = "🌺" },
                    { id = 36, name = "Frost Lotus", icon = "🪷" },
                    { id = 37, name = "Corrupted Seed", icon = "🫘" },
                    { id = 38, name = "Celestial Orb", icon = "🔮" },
                    { id = 39, name = "Arcane Rune", icon = "📜" },
                    { id = 40, name = "Elder Wood", icon = "🪵" },
                    { id = 41, name = "Mithril Ore", icon = "⛏️" },
                    { id = 42, name = "Obsidian Shard", icon = "⬛" },
                    { id = 43, name = "Amber Resin", icon = "🟠" },
                    { id = 44, name = "Pearl Essence", icon = "🫧" },
                    { id = 45, name = "Meteor Fragment", icon = "☄️" },
                    { id = 46, name = "Cosmic Dust", icon = "🌌" },
                    { id = 47, name = "Solar Flare", icon = "🌞" },
                    { id = 48, name = "Lunar Tear", icon = "🌜" },
                    { id = 49, name = "Storm Core", icon = "🌪️" },
                    { id = 50, name = "Magma Heart", icon = "🌋" },
                    { id = 51, name = "Ocean Pearl", icon = "🌊" },
                    { id = 52, name = "Forest Spirit", icon = "🧚" },
                    { id = 53, name = "Spectral Ash", icon = "💀" },
                    { id = 54, name = "Nectar Drop", icon = "🍯" },
                    { id = 55, name = "Fairy Dust", icon = "🧚‍♀️" },
                    { id = 56, name = "Vampire Fang", icon = "🧛" },
                    { id = 57, name = "Werewolf Fur", icon = "🐺" },
                    { id = 58, name = "Mummy Wrap", icon = "🧟" },
                    { id = 59, name = "Ectoplasm", icon = "👻" },
                    { id = 60, name = "Witch Brew", icon = "🧙" },
                    { id = 61, name = "Cursed Coin", icon = "🪙" },
                    { id = 62, name = "Blessed Water", icon = "💦" },
                    { id = 63, name = "Holy Symbol", icon = "✝️" },
                    { id = 64, name = "Dark Relic", icon = "🗿" },
                    { id = 65, name = "Chaos Shard", icon = "💥" },
                    { id = 66, name = "Harmony Bell", icon = "🔔" },
                    { id = 67, name = "Thunder Stone", icon = "🪨" },
                    { id = 68, name = "Prism Crystal", icon = "🌈" },
                    { id = 69, name = "Voidstone", icon = "⚫" },
                    { id = 70, name = "Sunstone", icon = "☀️" },
                    { id = 71, name = "Starlight Shard", icon = "⭐" },
                    { id = 72, name = "Dream Essence", icon = "💭" },
                }
            },
        },
    },

    ['scale'] = {
        settings = {
            ['regular'] = {
                timeLimit = 30,
                marginOfError = 2,
                numWeights = 30,
                minWeight = 5,
                maxWeight = 25,
            },
        }
    },

    ['hammer'] = {
        settings = {
            ['regular'] = {
                timeLimit = 30,
                chargeSpeed = 50,
                hitZoneSize = 15,
                hitZoneStart = 40,
                requiredHits = 3,
                cooldownDuration = 2,
            },
        }
    },

    ['heat'] = {
        settings = {
            ['regular'] = {
                timeLimit = 60,
                targetMin = 160,
                targetMax = 190,
                requiredTime = 3,
                heatChangeRate = 12,
                naturalCooling = 3.5,
                minTemp = 0,
                maxTemp = 300,
                momentumFactor = 0.85,
                targetZoneSpeed = 8,
                heatSpikeChance = 0.15,
                heatSpikeAmount = 25,
                requiredSuccesses = 3,
            },
        }
    },
}
