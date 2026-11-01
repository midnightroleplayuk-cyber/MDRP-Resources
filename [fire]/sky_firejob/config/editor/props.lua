Config.FireScenarioCreator = Config.FireScenarioCreator or {}
Config.FireScenarioCreator.assets = Config.FireScenarioCreator.assets or {}

local function formatPropLabel(model)
    local label = tostring(model or ""):gsub("^prop_", ""):gsub("^v_", ""):gsub("^cs_", "")
    label = label:gsub("_", " ")
    label = label:gsub("(%a)([%w']*)", function(first, rest)
        return first:upper() .. rest
    end)

    return label ~= "" and label or tostring(model or "Prop")
end

-- Public Forge list curation:
-- https://forge.plebmasters.de/datalists/69934e9b-fc73-4d7f-082a-08dc6ef9dc29
-- https://forge.plebmasters.de/datalists/0c38e1b3-b3c0-4b1c-4707-08dbf7eaed99
-- https://forge.plebmasters.de/datalists/9e614c2c-a89a-494c-84f0-08ddc51d61e8
local plebMasterProps = {
    "sky_water_monitor",
    "prop_barrier_work05",
    "prop_barrier_work06a",
    "prop_roadcone02a",
    "prop_roadcone02b",
    "prop_roadpole_01a",
    "prop_mp_barrier_02b",
    "prop_mp_arrow_barrier_01",
    "prop_mp_ramp_03",
    "prop_consign_01b",
    "prop_consign_02a",
    "prop_const_fence01a",
    "prop_const_fence02a",
    "prop_const_fence03a_cr",
    "prop_const_fence04a",
    "prop_const_fence05a",
    "prop_const_fence06a",
    "prop_skip_08a",
    "prop_skip_10a",
    "prop_skip_05a",
    "prop_dumpster_4a",
    "prop_dumpster_02a",
    "prop_dumpster_01a",
    "prop_tool_box_04",
    "prop_tool_bench02",
    "prop_worklight_03b",
    "prop_worklight_02a",
    "prop_generator_01a",
    "prop_generator_03b",
    "prop_aircon_l_03",
    "prop_cratepile_07a_l1",
    "prop_crate_11e",
    "prop_box_wood02a",
    "prop_box_wood03a",
    "prop_pallet_02a",
    "prop_pallet_01a",
    "prop_pipes_conc_03",
    "prop_pipes_03b",
    "prop_cementbags01",
    "prop_barrel_02a",
    "prop_barrel_exp_01a",
    "prop_rock_4_big2",
    "prop_rock_4_cl_2",
    "prop_rock_5_smash3",
    "prop_tree_fallen_02",
    "prop_w_r_cedar_dead",
    "prop_beach_lg_float",
    "prop_ld_farm_couch01",
    "prop_ld_farm_chair01",
    "prop_bin_05a",
    "prop_bin_10a",
    "prop_elecbox_12",
    "prop_phonebox_03",
    "prop_bench_01a",
    "prop_table_03",
    "prop_sign_road_01a",
    "prop_sign_road_06q",
    "prop_sign_road_06r",
    "prop_sign_road_05a",
    "prop_sign_road_03e",
    "prop_sign_road_04a",
    "prop_snow_sign_road_06g",
    "prop_traffic_01a",
    "prop_traffic_02a"
}

Config.FireScenarioCreator.assets.props = {}

for index, model in ipairs(plebMasterProps) do
    Config.FireScenarioCreator.assets.props[index] = {
        model = model,
        label = model == "sky_water_monitor" and "Water Monitor" or formatPropLabel(model),
        imageExt = model == "sky_water_monitor" and "png" or nil
    }
end
