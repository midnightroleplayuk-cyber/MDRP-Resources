Framework = nil
FrameWork = FrameWork or {}
FrameWork.Functions = FrameWork.Functions or {}
FrameWork.FrameworkLoaded = false
Voice = {}

Bridge = {
    name = "Standalone",
    resource = nil,
    core = nil,
    loaded = false
}

function Bridge:IsResourceActive(resourceName)
    local state = GetResourceState(resourceName)
    return state == "started" or state == "starting"
end

function Bridge:SafeCall(fn, ...)
    local ok, result = pcall(fn, ...)
    if ok then return result end
    return nil
end

function Bridge:DetectFramework(config)
    if type(config) ~= "table" then return nil end
    for i = 1, #config do
        local info = config[i]
        if info.resource and info.folder and self:IsResourceActive(info.resource) then
            return info
        end
    end
    return nil
end

function Bridge:GetStress()
    return Client and Client.PlayerData and Client.PlayerData.Stress or 0
end

function Bridge:Notify(title, text, type, duration)
    lib.notify({
        title = title,
        description = text,
        type = type,
        duration = duration
    })
end

function Bridge:Initialize()
    if not IsDuplicityVersion() then
        local info = self:DetectFramework(Settings.Frameworks)
        if info then
            local bridgePath = ("client.bridge.framework.%s.client"):format(info.folder)
            local loaded, bridgeModule = pcall(lib.load, bridgePath)
            if loaded and type(bridgeModule) == "table" then
                self.name = bridgeModule.Name or info.name
                self.resource = info.resource
                self.core = bridgeModule.Framework or bridgeModule.Core
                self.loaded = self.core ~= nil
                
                for name, fn in pairs(bridgeModule) do
                    if type(fn) == "function" then
                        self[name] = function(s, ...)
                            if s == self then
                                return fn(bridgeModule, ...)
                            else
                                return fn(bridgeModule, s, ...)
                            end
                        end
                    else
                        self[name] = fn
                    end
                end

                local meta = getmetatable(bridgeModule)
                if meta then
                    for name, fn in pairs(meta) do
                        if type(fn) == "function" and not name:find("^__") then
                            self[name] = function(s, ...)
                                if s == self then
                                    return fn(bridgeModule, ...)
                                else
                                    return fn(bridgeModule, s, ...)
                                end
                            end
                        end
                    end
                end

                Framework = self.core
                Settings.Framework = self.name
                FrameWork.FrameworkLoaded = self.loaded
            else
                if Settings and Settings.Debug then
                    print(("[tuff-hud][DEBUG] Failed to load client bridge: %s -> %s"):format(bridgePath, tostring(bridgeModule)))
                end
            end
        end

        local voiceConfig = Settings.Voices or {}
        for i = 1, #voiceConfig do
            local voiceInfo = voiceConfig[i]
            if voiceInfo.resource and voiceInfo.folder and self:IsResourceActive(voiceInfo.resource) then
                local voicePath = ("client.bridge.voice.%s.client"):format(voiceInfo.folder)
                local loaded, voiceModule = pcall(lib.load, voicePath)
                if loaded and type(voiceModule) == "table" then
                    Voice = voiceModule
                else
                    if Settings and Settings.Debug then
                        print(("[tuff-hud][DEBUG] Failed to load voice bridge: %s -> %s"):format(voicePath, tostring(voiceModule)))
                    end
                end
                break
            end
        end
    else
        local frameworks = Settings.Frameworks or {}
        for i = 1, #frameworks do
            local info = frameworks[i]
            if info.resource and self:IsResourceActive(info.resource) then
                self.resource = info.resource
                self.name = info.name
                
                if info.name == "ESX" then
                    self.core = self:SafeCall(function()
                        return exports['es_extended']:getSharedObject()
                    end)
                elseif info.name == "QBCore" then
                    self.core = self:SafeCall(function()
                        return exports['qb-core']:GetCoreObject()
                    end)
                elseif info.name == "Qbox" then
                    self.core = self:SafeCall(function()
                        return exports.qbx_core:GetCoreObject()
                    end)
                end

                self.loaded = self.core ~= nil
                Framework = self.core
                Settings.Framework = self.name
                FrameWork.FrameworkLoaded = self.loaded
                break
            end
        end

        function self:GetPlayer(src)
            if not src or not self.core then return nil end
            local s = tonumber(src) or src
            if self.name == "ESX" then
                return self.core.GetPlayerFromId(s)
            elseif self.name == "QBCore" or self.name == "Qbox" then
                return self.core.Functions and self.core.Functions.GetPlayer(s)
            end
            return nil
        end

        function self:GetPlayerMetadata(Player, key)
            if not Player then return nil end
            if self.name == "ESX" then
                if Player.getMeta then
                    return Player.getMeta(key)
                elseif Player.get and type(Player.get) == "function" then
                    return Player.get(key)
                end
                return nil
            elseif self.name == "QBCore" or self.name == "Qbox" then
                if Player.PlayerData and Player.PlayerData.metadata then
                    return Player.PlayerData.metadata[key]
                end
            end
            return nil
        end

        function self:SetPlayerMetadata(Player, key, value)
            if not Player then return false end
            if self.name == "ESX" then
                if Player.setMeta then
                    Player.setMeta(key, value)
                    return true
                elseif Player.set and type(Player.set) == "function" then
                    Player.set(key, value)
                    return true
                end
            elseif self.name == "QBCore" or self.name == "Qbox" then
                if Player.Functions and Player.Functions.SetMetaData then
                    Player.Functions.SetMetaData(key, value)
                    return true
                end
            end
            return false
        end
    end

    Settings.FrameworkSystems = self.loaded
end

Bridge:Initialize()