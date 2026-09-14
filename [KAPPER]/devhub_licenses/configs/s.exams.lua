-- ═══════════════════════════════════════════════════════════════════════════
--  License Exams / Tests  (SERVER-ONLY  —  keeps the correct answers off clients)
-- ═══════════════════════════════════════════════════════════════════════════

-- HOW IT WORKS
--   A license template listed in Config.LicenseExams.exams is NO LONGER auto-granted when a
--   player first joins (even if its "Auto Issue" flag is on in the license creator). Instead
--   the player must sit and pass this test at a License Pickup clerk. Passing GRANTS the
--   permission; the player then collects the physical license from the same clerk as usual.
--
--   Returning players who were already granted the license keep it — the test only gates the
--   initial grant.

Config.LicenseExams = Config.LicenseExams or {}

-- Exam definitions, keyed by license template NAME (the name set in the license creator, NOT
-- the label). Remove the sample below, or add your own entries, to match your templates.
Config.LicenseExams.exams = {

    ["weapon_license"] = {
        cost            = 250,     -- Booking fee to sit the test (0 = free). NON-REFUNDABLE — charged when the test starts, whether the player passes or fails.
        paymentMethod   = "both",  -- "cash" | "card" | "both" (only used when cost > 0)
        passingScore    = 70,      -- Percent of questions that must be correct to pass (0-100)
        questionCount   = 5,       -- Draw this many random questions from the pool below (nil / 0 = ask them all)
        shuffleQuestions = true,   -- Randomise the order questions are asked in
        shuffleAnswers  = true,    -- Randomise the order of answers within each question
        retryCooldown   = 300,     -- Seconds a player must wait after FAILING before retrying (0 = retry immediately)

        -- Question pool. `correct` is the 1-based index into `answers` of the right option
        -- (indices refer to the order written here; answers are shuffled per-player at runtime).
        questions = {
            {
                q = "What should you do when you approach a red traffic light?",
                answers = { "Come to a complete stop and wait", "Speed up to clear the junction", "Honk and continue", "Reverse away from it" },
                correct = 1,
            },
            {
                q = "What is the default speed limit in a residential area?",
                answers = { "30 mph", "50 mph", "70 mph", "No limit" },
                correct = 1,
            },
            {
                q = "When must you use your indicators?",
                answers = { "Before turning or changing lanes", "Only at night", "Only on the highway", "Never, they are optional" },
                correct = 1,
            },
            {
                q = "What does a solid double line in the centre of the road mean?",
                answers = { "Overtaking is prohibited", "You may overtake freely", "Parking is allowed here", "The road ends ahead" },
                correct = 1,
            },
            {
                q = "You are approaching a pedestrian crossing with people waiting. You should:",
                answers = { "Slow down and give way to pedestrians", "Maintain speed, they will wait", "Flash your lights and keep going", "Overtake the car in front" },
                correct = 1,
            },
            {
                q = "What is the correct action if an emergency vehicle approaches with sirens on?",
                answers = { "Pull over safely and let it pass", "Speed up to stay ahead of it", "Stop immediately in the middle of the road", "Ignore it and continue normally" },
                correct = 1,
            },
            {
                q = "When is it legal to use a handheld phone while driving?",
                answers = { "Never while the vehicle is moving", "Only in the city", "Only when stopped at lights", "Whenever you want" },
                correct = 1,
            },
            {
                q = "What should you check before changing lanes?",
                answers = { "Mirrors and blind spot", "Only the radio", "Nothing, just move over", "The fuel gauge" },
                correct = 1,
            },
        },
    },
}

function GetLicenseExam(templateName)
    if not (Config.LicenseExams and Config.LicenseExams.enabled) then return nil end
    if not templateName then return nil end
    local exams = Config.LicenseExams.exams
    return exams and exams[templateName] or nil
end
