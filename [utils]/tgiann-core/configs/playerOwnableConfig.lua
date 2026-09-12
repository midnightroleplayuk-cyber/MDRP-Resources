--[[
    Player Ownable (business / boss panel) override.

    tgiann-core ships a built-in player-ownable system: businesses/panels that a
    player can buy, pay rent for, hire employees to, and withdraw money from.
    Other tgiann scripts (rent-vehicle, clothing, food-jobs, vehicleshop,
    realparking, bank, shop) plug into it through the tgiann-core exports.

    If you already run your own ownership/business system and want tgiann scripts
    to use it instead, set `active = true` and implement the functions below.

    When active:
      - tgiann-core's built-in ownable system is fully disabled (no SQL loading,
        no rent/expiry threads, no job sync, no boss-menu markers, no DB table).
      - Every export the other tgiann scripts rely on is routed to your functions.
        It is all-or-nothing: while active you must implement all of them.

    Leave `active = false` (default) to keep the built-in system unchanged.
]]

---@class PlayerOwnablePanelData
---@field keyName string
---@field isBought boolean
---@field owner string
---@field money number
---@field price number
---@field priceType? string
---@field priceSymbol? string
---@field rentMoney number
---@field rentPeriodDay number
---@field rentPayBeforeDay number
---@field canRentTime number
---@field lastRentTime number
---@field canHireEmployee? boolean
---@field maxEmployee? number
---@field employeeList? { id: number, citizenId: string, name: string }[]
---@field tgiannShopData? { subCategory: string, name: string|table, description: string|table, image: string, coords: vector3 }

---@class PlayerOwnableClientPanel
---@field keyName string
---@field coords vector3
---@field ownerPanelText string
---@field disableDrawMarker? boolean
---@field drawMarkerDist? number

-- Each function errors until you replace it, so a missing override fails loudly
-- (the bodies are only ever reached when `active = true`).

configCore.playerOwnable = {
    override = {
        active = false,

        -- SERVER side. These run on the server.
        server = {
            ---Register a business/panel from a tgiann script's config. Called once
            ---per business when that script starts. Store it in your own system.
            ---@param data PlayerOwnableParam
            ---@return PlayerOwnablePanelData
            ---@diagnostic disable-next-line: unused-local
            createControlPanel = function(data) error("tgiann-core: playerOwnable override not implemented") end,

            ---Return one panel's current state (ownership, balance, rent, shop info).
            ---Return nil if it doesn't exist.
            ---@param keyName string
            ---@return PlayerOwnablePanelData?
            ---@diagnostic disable-next-line: unused-local
            getControlPanelData = function(keyName) error("tgiann-core: playerOwnable override not implemented") end,

            ---Return every panel keyed by keyName. tgiann-shop uses this to list
            ---all businesses in its UI.
            ---@return table<string, PlayerOwnablePanelData>
            getAllControlPanels = function() error("tgiann-core: playerOwnable override not implemented") end,

            ---Remove/reset a panel and clear its owner (e.g. when the shop is deleted
            ---or the rent expires).
            ---@param keyName string
            ---@diagnostic disable-next-line: unused-local
            deleteControlPanel = function(keyName) error("tgiann-core: playerOwnable override not implemented") end,

            ---Update one or more fields of a panel. `dataKey` is either a single
            ---field name (with `dataValue`) or a table of field -> value pairs.
            ---@param keyName string
            ---@param dataKey string|table
            ---@param dataValue? any
            ---@diagnostic disable-next-line: unused-local
            updateControlPanelData = function(keyName, dataKey, dataValue) error("tgiann-core: playerOwnable override not implemented") end,

            ---Add income to a panel's balance (e.g. a cut of a sale, rental or tax).
            ---@param keyName string
            ---@param money number
            ---@diagnostic disable-next-line: unused-local
            controlPanelAddMoney = function(keyName, money) error("tgiann-core: playerOwnable override not implemented") end,

            ---Player at `src` buys the panel: charge them and make them the owner.
            ---Return the panel data on success, or false if it failed.
            ---@param src number
            ---@param keyName string
            ---@return PlayerOwnablePanelData|false
            ---@diagnostic disable-next-line: unused-local
            controlPanelBuy = function(src, keyName) error("tgiann-core: playerOwnable override not implemented") end,

            ---Owner at `src` withdraws the panel's balance to their pocket.
            ---@param src number
            ---@param keyName string
            ---@return PlayerOwnablePanelData|false
            ---@diagnostic disable-next-line: unused-local
            controlPanelGetMoney = function(src, keyName) error("tgiann-core: playerOwnable override not implemented") end,

            ---Owner at `src` pays the panel's rent and extends its rental period.
            ---@param src number
            ---@param keyName string
            ---@return PlayerOwnablePanelData|false
            ---@diagnostic disable-next-line: unused-local
            controlPanelPayRent = function(src, keyName) error("tgiann-core: playerOwnable override not implemented") end,

            ---Return the panels a player owns (and, when includeEmployee is true,
            ---the ones they work at) as { [keyName] = { owner = bool } }.
            ---@param citizenId string
            ---@param includeEmployee? boolean
            ---@return table<string, { owner: boolean }>
            ---@diagnostic disable-next-line: unused-local
            getPlayerControlPanelKeyNames = function(citizenId, includeEmployee) error("tgiann-core: playerOwnable override not implemented") end,

            ---Decide what the built-in boss-menu client shows this player: the buy
            ---screen, the owner menu, or an "already owned by someone else" state.
            ---@param src number
            ---@param keyName string
            ---@return { buyed: boolean, owner?: boolean, data?: PlayerOwnablePanelData, price?: number, rentPeriodDay?: number, priceSymbol?: string }
            ---@diagnostic disable-next-line: unused-local
            getControlPanelDataForPlayer = function(src, keyName) error("tgiann-core: playerOwnable override not implemented") end,

            ---Check whether a player is the owner or employee of the ownable tied to
            ---`jobName`. Return isMember, its keyName, and the role.
            ---@param citizenId string
            ---@param jobName string
            ---@return boolean isMember, string? keyName, string? role
            ---@diagnostic disable-next-line: unused-local
            isPlayerInOwnableForJob = function(citizenId, jobName) error("tgiann-core: playerOwnable override not implemented") end,

            ---Return the player's business purchase history. tgiann-shop shows this
            ---in its "my purchases" screen.
            ---@param citizenId string
            ---@return { id: number, citizenId: string, keyName: string, price: number, priceType: string, purchasedAt: number }[]
            ---@diagnostic disable-next-line: unused-local
            getBusinessPurchases = function(citizenId) error("tgiann-core: playerOwnable override not implemented") end,

            ---Owner at `src` offers to transfer `keyName` to `targetCitizenId`, for
            ---`price` (0 = free). Send the target an accept/decline prompt; do not
            ---transfer ownership yet, that happens in `respondTransfer`.
            ---@param src number
            ---@param keyName string
            ---@param targetCitizenId string
            ---@param price number
            ---@diagnostic disable-next-line: unused-local
            requestTransfer = function(src, keyName, targetCitizenId, price) error("tgiann-core: playerOwnable override not implemented") end,

            ---Target player at `src` responds to a pending transfer offer for `keyName`.
            ---If accepted, charge them `price` (when > 0), pay the previous owner, and
            ---make them the new owner.
            ---@param src number
            ---@param keyName string
            ---@param accepted boolean
            ---@diagnostic disable-next-line: unused-local
            respondTransfer = function(src, keyName, accepted) error("tgiann-core: playerOwnable override not implemented") end,
        },

        -- CLIENT side. These run on each player's client.
        client = {
            ---Return true if the local player owns `keyName` (or works there when
            ---includeEmployee is true). Guards owner-only menus and prompts.
            ---@param keyName string
            ---@param includeEmployee? boolean
            ---@return boolean
            ---@diagnostic disable-next-line: unused-local
            playerHasOwnable = function(keyName, includeEmployee) error("tgiann-core: playerOwnable override not implemented") end,

            ---Return the local player's panels as { [keyName] = { owner = bool } }.
            ---@param includeEmployee? boolean
            ---@return table<string, { owner: boolean }>
            ---@diagnostic disable-next-line: unused-local
            getPlayerControlPanelKeyNames = function(includeEmployee) error("tgiann-core: playerOwnable override not implemented") end,

            ---Register a boss/owner interaction point. Draw your own marker and open
            ---your menu here (the built-in marker/text is disabled while active).
            ---@param data PlayerOwnableClientPanel
            ---@diagnostic disable-next-line: unused-local
            registerPlayerOwnablePanel = function(data) error("tgiann-core: playerOwnable override not implemented") end,

            ---Remove a previously registered interaction point.
            ---@param keyName string
            ---@diagnostic disable-next-line: unused-local
            removePlayerOwnablePanel = function(keyName) error("tgiann-core: playerOwnable override not implemented") end,

            ---Update a registered interaction point (e.g. move its coords). `dataKey`
            ---is a single field name (with `dataValue`) or a field -> value table.
            ---@param keyName string
            ---@param dataKey string|table
            ---@param dataValue? any
            ---@diagnostic disable-next-line: unused-local
            updatePlayerOwnablePanel = function(keyName, dataKey, dataValue) error("tgiann-core: playerOwnable override not implemented") end,

            ---Open your boss/owner menu for `keyName`.
            ---@param keyName string
            ---@diagnostic disable-next-line: unused-local
            openPlayerOwnableBossMenu = function(keyName) error("tgiann-core: playerOwnable override not implemented") end,
        },
    },
}
