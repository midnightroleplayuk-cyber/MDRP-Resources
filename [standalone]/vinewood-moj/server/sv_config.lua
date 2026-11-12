-- Server-only settings. This file is a server_script, so it is never sent to players.
SvConfig = {}

-- Discord webhooks. Paste a channel's webhook URL (Channel settings → Integrations → Webhooks).
-- Leave a channel empty to switch it off. Several channels can share one URL.
SvConfig.Webhooks = {
    Username = 'Ministry of Justice',
    Avatar = '',              -- image URL, optional
    Channels = {
        cases = '',           -- cases opened, hearings listed/opened/adjourned, pleas, verdicts, bail and remand, withdrawals
        sentences = '',       -- every sentence, with who passed it (judge or auto court)
        warrants = '',        -- failure to appear, fine default, breach, recall and escape warrants; executed and cancelled
        custody = '',         -- defendants booked in at the court custody desk
        prison = '',          -- received into custody, released (and early releases), recalled, escapes
        probation = '',       -- orders, appointments, warnings, breaches, curfew and exclusion zone alerts, unpaid work
        fines = '',           -- court fines issued, paid, in default and written off
        civil = '',           -- civil claims: issued, defended, listed, heard, judgment, payments, CCJs, withdrawn/settled
        evidence = '',        -- video exhibits added or removed, and footage shown on courtroom screens
        courtrooms = '',      -- admins creating, editing or deleting courtrooms and their laptops, mics, desks and screens
        all = '',             -- optional: a copy of every message from every channel above
    },
    -- Optional pings, sent with that channel's messages. Role: '<@&ROLE_ID>', user: '<@USER_ID>'.
    Mentions = {
        -- warrants = '<@&123456789012345678>',
        -- custody = '<@&123456789012345678>',
    },
}
