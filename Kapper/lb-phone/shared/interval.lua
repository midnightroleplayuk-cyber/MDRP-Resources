---@type { [number]: boolean }
local intervals = {}

---@class Interval
---@field id? number
---@field handler fun(self: Interval): any
---@field interval number
---@field enabled boolean
---@field remove fun(self: Interval): nil
---@field toggle fun(self: Interval, enabled?: boolean): nil
---@field onStart? fun(self: Interval): nil
---@field onStop? fun(self: Interval): nil

---@class Interval
Interval = {}
Interval.__index = Interval

---@param handler fun(self: Interval): any
---@param interval? number
---@param enabled? boolean
---@return Interval interval
function Interval:new(handler, interval, enabled)
    self = setmetatable({}, self)

    self.handler = handler
    self.interval = interval or 0

    self:toggle(enabled)

    return self
end

---@param enabled? boolean
function Interval:toggle(enabled)
    enabled = enabled == nil or enabled == true

    if self.enabled == enabled then
        return
    end

    self.enabled = enabled

    if not enabled then
        if self.id then
            intervals[self.id] = nil

            if self.onStop then
                self:onStop()
            end
        end

        return
    end

    Citizen.CreateThreadNow(function(ref)
        self.id = ref

        intervals[ref] = true

        if self.onStart then
            self:onStart()
        end

        while intervals[ref] do
            if self.enabled then
                self:handler()
                Wait(self.interval)
            else
                Wait(0)
            end
        end
    end)
end

function Interval:remove()
    if self and self.id then
        intervals[self.id] = nil
    end
end
