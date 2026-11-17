-- Discord webhook URLs for GoodCiv logs.
-- This file is a server script only, so it is never sent to players.
-- Do NOT move these into config.lua (that file is downloaded by every client).

Webhooks = {
    -- Used for every category that doesn't have its own URL below.
    default = 'https://discord.com/api/webhooks/1569897859384479765/8CFlYNJ1kPPjUUJr7-DAdVQZnZcQxpd-QbB8YzdG_EhQK_TY7nMsh_A8oBTgcC8Kvg18',

    -- Optional: send a category to its own channel. Leave '' to use default.
    carriers = '',   -- sign up / sign off, training
    incidents = '',  -- calls raised, accepted, abandoned, closed
    treatment = '',  -- tourniquet, CPR, rouse, load, crashes
    rewards = '',    -- paid / withheld rewards
    admin = '',      -- admin commands
}
