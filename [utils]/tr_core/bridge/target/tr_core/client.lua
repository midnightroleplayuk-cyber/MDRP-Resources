-- tr_core's own interaction (tr_core/client/interact.lua): the default target. It takes ox_target-format
-- options, so this bridge passes them through; it removes a resource's options when that resource stops.
local core = exports.tr_core

local bridge = {}

function bridge.addBoxZone(data) return core:addBoxZone(data) end
function bridge.addSphereZone(data) return core:addSphereZone(data) end
function bridge.addPolyZone(data) return core:addPolyZone(data) end
function bridge.removeZone(id) core:removeZone(id) end

function bridge.addModel(models, options) core:addModel(models, options) end
function bridge.removeModel(models, names) core:removeModel(models, names) end

function bridge.addEntity(netIds, options) core:addEntity(netIds, options) end
function bridge.removeEntity(netIds, names) core:removeEntity(netIds, names) end

function bridge.addLocalEntity(entities, options) core:addLocalEntity(entities, options) end
function bridge.removeLocalEntity(entities, names) core:removeLocalEntity(entities, names) end

function bridge.addGlobalPed(options) core:addGlobalPed(options) end
function bridge.removeGlobalPed(names) core:removeGlobalPed(names) end
function bridge.addGlobalVehicle(options) core:addGlobalVehicle(options) end
function bridge.removeGlobalVehicle(names) core:removeGlobalVehicle(names) end
function bridge.addGlobalObject(options) core:addGlobalObject(options) end
function bridge.removeGlobalObject(names) core:removeGlobalObject(names) end
function bridge.addGlobalPlayer(options) core:addGlobalPlayer(options) end
function bridge.removeGlobalPlayer(names) core:removeGlobalPlayer(names) end

return bridge
