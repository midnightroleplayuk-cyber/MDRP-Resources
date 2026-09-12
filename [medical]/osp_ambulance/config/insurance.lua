Config = Config or {}

Config.CheckInNPCModel = 's_m_m_doctor_01'
Config.CheckInNPCScenario = 'WORLD_HUMAN_CLIPBOARD'

-- Built-in plans sold at hospital check-in. Set to false to use an external insurance resource instead.
-- Client hook: HandleExternalInsuranceMenu in client_open.lua
-- Server hook: GetExternalInsurance in server_open.lua
Config.UseBuiltInInsurance = false

-- Insurance plans purchased at the hospital check-in NPC.
-- checkInDiscount: 0.0-1.0 fraction removed from check-in / hospital bill cost
-- freeMedications: medication ids from Config.PrescriptionMedications that are free when redeeming
-- durationDays: how long the plan lasts (nil = until another plan is purchased)
Config.InsurancePlans = {
    {
        id = 'basic',
        label = 'Basic Coverage',
        description = '10% off check-in. Covers cough syrup and paracetamol.',
        price = 750,
        durationDays = 7,
        checkInDiscount = 0.10,
        freeMedications = {
            'cough_syrup',
            'paracetamol',
        },
        icon = 'fa-solid fa-shield-halved',
    },
    {
        id = 'standard',
        label = 'Standard Coverage',
        description = '25% off check-in. Covers common prescription medications.',
        price = 2000,
        durationDays = 14,
        checkInDiscount = 0.25,
        freeMedications = {
            'cough_syrup',
            'paracetamol',
            'xanax',
            'melatonin',
        },
        icon = 'fa-solid fa-shield',
    },
    {
        id = 'premium',
        label = 'Premium Coverage',
        description = '50% off check-in. Most prescription medications included.',
        price = 5000,
        durationDays = 30,
        checkInDiscount = 0.50,
        freeMedications = {
            'cough_syrup',
            'paracetamol',
            'tramadol',
            'vicodin',
            'xanax',
            'melatonin',
        },
        icon = 'fa-solid fa-shield-heart',
    },
}
