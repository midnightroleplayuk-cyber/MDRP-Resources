---@class Check
---@field id number
---@field event CheckEvent
---@field action fun(...): boolean
---@field resource string

---@type { [string]: Check[] }
local checks = {}
local checkId = 0

---@alias CheckEvent
---| "openPhone"
---| "createDarkChatChannel"
---| "joinDarkChatChannel"
---| "sendDarkchatMessage"
---| "startInstaPicLive"
---| "joinInstaPicLive"
---| "postInstaPicStory"
---| "postInstaPic"
---| "postBirdy"
---| "postTrendy"
---| "buyCrypto"
---| "sellCrypto"
---| "transferCrypto"
---| "playNativePhoneSound"
---| "postMarketplace"
---| "postPages"

---@param event CheckEvent
---@param handler fun(...: any): boolean
---@overload fun(event: "openPhone", handler: fun(): boolean): number
---@overload fun(event: "startInstaPicLive", handler: fun(source: number, username: string): boolean): number
---@overload fun(event: "joinInstaPicLive", handler: fun(source: number, username: string, inviter: string): boolean): number
---@overload fun(event: "postInstaPicStory", handler: fun(source: number, username: string): boolean): number
---@overload fun(event: "postInstaPic", handler: fun(source: number, username: string, media: string[], caption?: string, location?: string): boolean): number
---@overload fun(event: "postBirdy", handler: fun(source: number, username: string, content?: string, attachments?: string[]): boolean): number
---@overload fun(event: "postTrendy", handler: fun(source: number, username: string, video: string, caption: string): boolean): number
---@overload fun(event: "buyCrypto", handler: fun(source: number, coin: string, amount: number): boolean): number
---@overload fun(event: "sellCrypto", handler: fun(source: number, coin: string, amount: number): boolean): number
---@overload fun(event: "transferCrypto", handler: fun(source: number, transferToNumber: string, coin: string, amount: number): boolean): number
---@overload fun(event: "createDarkChatChannel", handler: fun(source: number, username: string, channel: string): boolean): number
---@overload fun(event: "joinDarkChatChannel", handler: fun(source: number, username: string, channel: string): boolean): number
---@overload fun(event: "sendDarkchatMessage", handler: fun(source: number, username: string, channel: string, message: string): boolean): number
---@overload fun(event: "playNativePhoneSound", handler: fun(soundType: string, soundName?: string): boolean): number
---@overload fun(event: "postMarketplace", handler: fun(source: number, post: { title: string, description: string, attachments: string[], price: number }): boolean): number
---@overload fun(event: "postPages", handler: fun(source: number, post: { title: string, description: string, attachment?: string, price?: number }): boolean): number
---@return number id
function AddCheck(event, handler)
    local resource = GetInvokingResource()

    checkId += 1

    if not checks[event] then
        checks[event] = {}
    end

    ---@type Check
    local check = {
        id = checkId,
        event = event,
        action = handler,
        resource = resource,
    }

    table.insert(checks[event], check)

    return checkId
end

exports("AddCheck", AddCheck)

---@param id number
---@return boolean success
function RemoveCheck(id)
    for _, eventChecks in pairs(checks) do
        for i = 1, #eventChecks do
            local check = eventChecks[i]

            if check.id == id then
                table.remove(eventChecks, i)
                return true
            end
        end
    end

    return false
end

exports("RemoveCheck", RemoveCheck)

---@param event CheckEvent
---@return boolean
function ValidateChecks(event, ...)
    if not checks[event] then
        return true
    end

    local eventChecks = checks[event]

    for i = 1, #eventChecks do
        local check = eventChecks[i]
        local success, allowed = pcall(function(...)
            return check.action(...)
        end, ...)

        if not success then
            local stackTrace = Citizen.InvokeNative(`FORMAT_STACK_TRACE` & 0xFFFFFFFF, nil, 0, Citizen.ResultAsString())

            print(("^1SCRIPT ERROR: Check '%s' (id %i, by resource '%s') failed: %s^7\n%s"):format(event, i, check.resource, allowed or "", stackTrace or ""))
        end

        if allowed == false then
            return false
        end
    end

    return true
end

AddEventHandler("onResourceStop", function()
    local resource = GetInvokingResource()

    for _, eventChecks in pairs(checks) do
        for i = #eventChecks, 1, -1 do
            local check = eventChecks[i]

            if check.resource == resource then
                table.remove(eventChecks, i)
            end
        end
    end
end)
