-- Anim native hook. Load this file in any resource's fxmanifest and every anim / scenario
-- that resource plays on the player ped is reported automatically, no code changes needed:
--     client_script "@tgiann-core/client/animHook.lua"
-- Works for direct native calls and for wrappers like lib.playAnim / tgiCore.PlayAnim,
-- because natives resolve from the resource's globals at call time.
--
-- Clients cannot write replicated state bags, so the report goes through the
-- tgiann-core server ("tgiann-core:animReport"), which sets the player statebag "tgiannAnim"
-- ({ d = dict, c = clip, f = flag } | { s = scenarioName } | false = none). Nearby recording
-- systems like tgiann-bodycam read that bag. A watcher clears the report when the anim
-- breaks on its own (movement, ragdoll, death).
--
-- This file must stay dependency free (no ox_lib, no tgiCore), it runs inside foreign resources.

local stateKey = "tgiannAnim"
local reportEvent = "tgiann-core:animReport"
local current = nil
local watching = false
local graceUntil = 0

local _TaskPlayAnim = TaskPlayAnim
local _TaskPlayAnimAdvanced = TaskPlayAnimAdvanced
local _TaskStartScenarioInPlace = TaskStartScenarioInPlace
local _TaskStartScenarioAtPosition = TaskStartScenarioAtPosition
local _ClearPedTasks = ClearPedTasks
local _ClearPedTasksImmediately = ClearPedTasksImmediately
local _ClearPedSecondaryTask = ClearPedSecondaryTask
local _StopAnimTask = StopAnimTask

local function sameReport(a, b)
    if type(a) ~= "table" or type(b) ~= "table" then return false end
    return a.d == b.d and a.c == b.c and a.s == b.s and a.f == b.f
end

---Clear the shared report, also when it was set by another resource's hook instance
---(a ClearPedTasks here breaks that anim too)
local function reportStop()
    local hadOwn = current ~= nil
    current = nil
    -- the bag lags one server round trip behind, hadOwn covers a clear right after a report
    if hadOwn or type(LocalPlayer.state[stateKey]) == "table" then
        TriggerServerEvent(reportEvent, false)
    end
end

---While this instance's report is active, clear it when the ped no longer plays it
local function startWatcher()
    if watching then return end
    watching = true
    CreateThread(function()
        while current do
            Wait(300)
            if not current then break end
            -- grace also covers the server round trip that fills the bag
            if GetGameTimer() >= graceUntil then
                local bag = LocalPlayer.state[stateKey]
                if type(bag) ~= "table" or not sameReport(bag, current) then
                    current = nil -- superseded by another resource's report, that instance watches now
                    break
                end
                local ped = PlayerPedId()
                local broken
                if current.s then
                    broken = not PedHasUseScenarioTask(ped)
                else
                    broken = not IsEntityPlayingAnim(ped, current.d, current.c, 3)
                end
                if broken then
                    current = nil
                    TriggerServerEvent(reportEvent, false)
                    break
                end
            end
        end
        watching = false
    end)
end

---@param data table { d, c, f } | { s }
---@param graceMs? number
local function report(data, graceMs)
    graceUntil = GetGameTimer() + (graceMs or 800)
    if current and sameReport(current, data) then return end -- re-tasked loop, no re-send
    current = data
    TriggerServerEvent(reportEvent, data)
    startWatcher()
end

function TaskPlayAnim(ped, animDict, animName, blendIn, blendOut, duration, flag, playbackRate, lockX, lockY, lockZ)
    _TaskPlayAnim(ped, animDict, animName, blendIn, blendOut, duration, flag, playbackRate, lockX, lockY, lockZ)
    if ped == PlayerPedId() then
        report({ d = animDict, c = animName, f = flag or 0 })
    end
end

function TaskPlayAnimAdvanced(ped, animDict, animName, posX, posY, posZ, rotX, rotY, rotZ, animEnterSpeed, animExitSpeed, duration, flag, animTime, rotOrder, ikFlags)
    _TaskPlayAnimAdvanced(ped, animDict, animName, posX, posY, posZ, rotX, rotY, rotZ, animEnterSpeed, animExitSpeed, duration, flag, animTime, rotOrder, ikFlags)
    if ped == PlayerPedId() then
        report({ d = animDict, c = animName, f = flag or 0 })
    end
end

function TaskStartScenarioInPlace(ped, scenarioName, unkDelay, playEnterAnim)
    _TaskStartScenarioInPlace(ped, scenarioName, unkDelay, playEnterAnim)
    if ped == PlayerPedId() then
        report({ s = scenarioName }, 3000)
    end
end

function TaskStartScenarioAtPosition(ped, scenarioName, x, y, z, heading, duration, sittingScenario, teleport)
    _TaskStartScenarioAtPosition(ped, scenarioName, x, y, z, heading, duration, sittingScenario, teleport)
    if ped == PlayerPedId() then
        report({ s = scenarioName }, 3000)
    end
end

function ClearPedTasks(ped)
    _ClearPedTasks(ped)
    if ped == PlayerPedId() then reportStop() end
end

function ClearPedTasksImmediately(ped)
    _ClearPedTasksImmediately(ped)
    if ped == PlayerPedId() then reportStop() end
end

function ClearPedSecondaryTask(ped)
    _ClearPedSecondaryTask(ped)
    if ped ~= PlayerPedId() then return end
    -- only clears the secondary task slot, so only drop a secondary (upper body, flag 32) anim report
    local bag = LocalPlayer.state[stateKey]
    local own = current or (type(bag) == "table" and bag or nil)
    if own and not own.s and (own.f or 0) & 32 ~= 0 then reportStop() end
end

function StopAnimTask(ped, animDict, animName, blendOut)
    _StopAnimTask(ped, animDict, animName, blendOut)
    if ped ~= PlayerPedId() then return end
    local bag = LocalPlayer.state[stateKey]
    local own = current or (type(bag) == "table" and bag or nil)
    if own and own.d == animDict and own.c == animName then reportStop() end
end
