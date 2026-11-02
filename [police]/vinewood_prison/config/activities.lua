Config.Activities = {
    -- Education: one lesson per visit to a classroom point, a question at the end of each.
    -- Lessons only run in work phases (education counts as work) and are paid.
    Education = {
        LessonDuration = 20000,
        LessonPay = 2,
        QualificationPoints = 2,   -- positive behaviour entry when a course is passed
        Courses = {
            food_hygiene = {
                label = 'Level 2 Food Hygiene',
                lessons = {
                    { title = 'Handwashing', q = 'When must you wash your hands in a kitchen?', options = { 'Only at the start of a shift', 'Before handling food and after touching raw meat', 'Only when they look dirty' }, answer = 2 },
                    { title = 'Temperatures', q = 'Where should high-risk food be kept?', options = { 'On the side', 'In the fridge below 5°C', 'In a warm cupboard' }, answer = 2 },
                    { title = 'Cross-contamination', q = 'Why use separate boards for raw meat?', options = { 'To stop bacteria spreading', 'It looks tidier', 'It is quicker' }, answer = 1 },
                },
            },
            health_safety = {
                label = 'Health and Safety at Work',
                lessons = {
                    { title = 'Hazards', q = 'What should you do if you see a spill on the floor?', options = { 'Ignore it', 'Report or clean it and warn others', 'Walk round it' }, answer = 2 },
                    { title = 'Manual handling', q = 'How should you lift a heavy box?', options = { 'Bend your back', 'Bend your knees and keep it close', 'Lift it above your head' }, answer = 2 },
                    { title = 'Tools', q = 'What do you check before using a power tool?', options = { 'The cable and guards are not damaged', 'The colour', 'Nothing' }, answer = 1 },
                },
            },
            maths_l1 = {
                label = 'Functional Skills Maths Level 1',
                lessons = {
                    { title = 'Percentages', q = 'What is 10% of 250?', options = { '2.5', '25', '250' }, answer = 2 },
                    { title = 'Money', q = 'You have £20 and spend £7.40. What is left?', options = { '£12.60', '£13.40', '£12.40' }, answer = 1 },
                    { title = 'Time', q = 'A shift starts at 08:30 and lasts 3h 15m. When does it end?', options = { '11:15', '11:45', '12:15' }, answer = 2 },
                },
            },
            english_l1 = {
                label = 'Functional Skills English Level 1',
                lessons = {
                    { title = 'Punctuation', q = 'Which sentence is correct?', options = { "its a nice day", "It's a nice day.", "Its' a nice day." }, answer = 2 },
                    { title = 'Formal writing', q = 'How should a formal letter to a stranger end?', options = { 'Yours faithfully', 'Cheers', 'Love from' }, answer = 1 },
                    { title = 'Reading', q = 'What is a summary?', options = { 'A copy of the whole text', 'The main points in fewer words', 'A list of hard words' }, answer = 2 },
                },
            },
        },
    },

    Gym = {
        Duration = 15000,
        MaxPerPhase = 6,
        minIep = 'basic',
        Exercises = {
            weights = { label = 'Free weights', anim = { scenario = 'WORLD_HUMAN_MUSCLE_FREE_WEIGHTS' } },
            chinups  = { label = 'Chin-ups', anim = { scenario = 'PROP_HUMAN_MUSCLE_CHIN_UPS' } },
            situps   = { label = 'Sit-ups', anim = { scenario = 'WORLD_HUMAN_SIT_UPS' } },
            pushups  = { label = 'Press-ups', anim = { scenario = 'WORLD_HUMAN_PUSH_UPS' } },
            yoga     = { label = 'Stretching', anim = { scenario = 'WORLD_HUMAN_YOGA' } },
        },
    },

    Library = {
        Duration = 30000,
        BooksForEntry = 5,          -- positive entry every N books read (0 = off)
        anim = { dict = 'cellphone@', clip = 'cellphone_text_read_base',
            prop = { model = 'prop_novel_01', bone = 6286, pos = vec3(0.15, 0.03, -0.065), rot = vec3(0.0, 180.0, 90.0) } },
    },

    Shower = {
        Duration = 15000,
        anim = { dict = 'mp_safehouseshower@male@', clip = 'male_shower_idle_a' },
        -- Optional stress relief: client-side TriggerServerEvent(event, amount), e.g. qb-hud / qbx_hud
        Stress = { enabled = false, event = 'hud:server:RelieveStress', amount = 15 },
    },

    -- Activities are allowed when cells are unlocked (not in lock-up phases) and not in segregation
}
