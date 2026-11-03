-- SMX uses native ESX inventory or exposes Quasar-compatible player exports.
-- Its GetContainerInventory getter creates missing storage, so vehicle scent
-- reads use the committed storage schema instead (SMX inventory 1.2.3).
if Sky.Config.inventory ~= "esx" and Sky.Config.inventory ~= "qs" then return end
if not IsDuplicityVersion() then return end
if GetResourceState("smx-inventory") == "missing" then return end

local tables = { trunk = "smx_inventory_trunks", glovebox = "smx_inventory_gloveboxes" }

function Sky.FW.GetVehicleInventoryItems(plate, compartment, _net_id)
    local storage = tables[compartment]
    if not storage or type(plate) ~= "string" or not plate:find("%S") or #plate > 80 or plate:find("%c") then
        Sky.Debug("error", "[inventory] SMX vehicle read rejected: invalid plate or compartment")
        return nil, "invalid_target"
    end
    if GetResourceState("smx-inventory") ~= "started" or not exports["smx-inventory"]:IsReady() then
        return nil, "unavailable"
    end
    plate = plate:match("^%s*(.-)%s*$")
    -- An unresolved provider mutation is not a reliable positive/negative scent.
    local pending = Sky.DB.Select("SELECT operation_key FROM smx_inventory_operations WHERE status IN ('pending', 'review_required') AND JSON_CONTAINS(details_json, ?, '$.containers') LIMIT 1",
        { json.encode({ type = compartment, id = plate }) })
    if not pending or #pending > 0 then return nil, "unavailable" end
    local rows = Sky.DB.Select("SELECT data FROM " .. storage .. " WHERE identifier = ? LIMIT 1", { plate })
    if not rows then return nil, "unavailable" end
    -- SMX persists every container before publishing it. No row means this
    -- compartment has never stored items; reading it must not insert a row.
    if not rows[1] then return {} end
    local ok, items = pcall(json.decode, rows[1].data)
    if not ok or type(items) ~= "table" then
        Sky.Debug("error", "[inventory] SMX vehicle storage contains invalid item JSON")
        return nil, "invalid_data"
    end
    return SkyInventoryHelpers.NormalizeStorageItems(items)
end
