-- Server-only settings. This file is a server_script, so it is never sent to players.
SvConfig = {}

-- Discord webhooks. Leave a channel empty to switch it off.
SvConfig.Webhooks = {
    Username = 'Ministry of Justice',
    Avatar = '',              -- image URL, optional
    Channels = {
        cases = '',           -- cases opened, hearings, pleas, verdicts, adjournments
        sentences = '',       -- every sentence, with who passed it (judge or auto court)
        warrants = '',        -- failure to appear, fine default, breach warrants
        prison = '',          -- received into custody, released, recalled
        probation = '',       -- orders, appointments, warnings, breaches, curfew and exclusion alerts
        fines = '',           -- court fines issued and paid
    },
}
