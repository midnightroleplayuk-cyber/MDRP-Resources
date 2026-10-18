# Advanced Chop Shop

Congratulations on purchasing FiveM's most popular Chop Shop resource! Version 3 is a ground-up rewrite focused on a fully in-game, database-backed configuration experience and a more interactive, hands-on chopping loop for your players. Keep reading to learn what's new.

# What's New in v3?

- **In-game admin panel**: configure everything from a searchable NUI panel (`/chopadmin`, ACE-gated to `lation_chopshop.admin`). No more editing Lua config files and restarting.
- **Database-backed config**: settings live in the `lation_chopshop_config` table, load on start, and sync to every client live when you save. Most edits apply without a restart.
- **Contract-based jobs**: players take a timed contract for a vehicle class from an allowed list, find a matching vehicle, and earn a bonus for finishing on time. Contracts survive a relog and a server restart, and the broker can reprint a lost contract.
- **Hands-on prep and minigames**: jack the vehicle up on stands, then work through the wheel lug-nut minigame, drill the hinge bolts out of each door so it drops to the ground, and dismantle the engine bay through an interactive hub with torque, connector and tap mechanics.
- **Swap Shop**: turn salvaged parts in at the broker for cash or items, with every payout configurable.
- **Built-in leveling and rewards**: configurable XP thresholds and per-level XP rewards, with an in-panel overview dashboard (players, vehicles, parts, and a 7-day activity chart broken down per part).
- **Import / export**: move a full configuration between servers as a single versioned JSON artifact.
- **Broad framework support**: ESX, QBCore and Qbox, with Modern Interact, ox_target and qb-target detected automatically, plus the major inventories, notify, progress and menu systems.
- **In-depth logging**: Fivemanage and Discord webhook support.

# Configuration

Everything is configured from the in-game admin panel. Open it with `/chopadmin` (requires the `lation_chopshop.admin` ACE permission) and edit any section: Setup, Start, Contracts, Locations, Items, Minigame, Experience, Shops and Logs. Changes autosave and sync to connected players. Sections that require a resource restart to take effect are marked in the panel.

Defaults are seeded into the database automatically on first start, so a fresh install works out of the box. Upgrading from v2? Your player level/stat data is migrated automatically; your v2 Lua config settings are not carried over, so re-enter your customizations in the admin panel (or import a config artifact).

# Install Instructions

A step-by-step guide is provided in the `lation_chopshop/install` folder ("Install Instructions") that links to our documentation describing how to properly install this resource. You can also find that page here: https://lationscripts.com/docs/chop-shop/install

# Thank You

Thanks for your purchase from Lation Scripts! We're excited to share this resource with you. If you have any questions, need support or have suggestions, we're always available via our Discord (https://discord.gg/9EbY4nM5uu) or through email at support@lationscripts.com.
