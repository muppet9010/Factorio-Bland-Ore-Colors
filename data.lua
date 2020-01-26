local Constants = require("constants")
local Utils = require("utility/utils")
--local Logging = require("utility/logging")

local function GetColorForSetting(oreColor, settingValue)
    if settingValue == "vanilla" then
        return oreColor
    elseif settingValue == "dull" then
        oreColor[4] = 0.8
    elseif settingValue == "bland" then
        local difR = (0.5 - oreColor[1]) / 4 * 3
        oreColor[1] = oreColor[1] + difR
        local difG = (0.5 - oreColor[2]) / 4 * 3
        oreColor[2] = oreColor[2] + difG
        local difB = (0.5 - oreColor[3]) / 4 * 3
        oreColor[3] = oreColor[3] + difB
        oreColor[4] = 0.8
    elseif settingValue == "grey" then
        oreColor = {0.3, 0.3, 0.3, 0.8}
    elseif settingValue == "invisible" then
        oreColor = {0, 0, 0, 0}
    end
    return oreColor
end

local entityColorModeSetting = settings.startup["bland_ore_colors-entity_color_mode"].value
local mapColorModeSetting = settings.startup["bland_ore_colors-map_color_mode"].value
local mapHighlightingSetting = settings.startup["bland_ore_colors-enable_map_highlighting"].value

local oreList = {"iron-ore", "copper-ore", "coal", "stone", "uranium-ore"}
local oreEntityColors, oreMapColors = {}, {}
for _, name in pairs(oreList) do
    oreEntityColors[name] = Utils.DeepCopy(data.raw["resource"][name].map_color)
    oreEntityColors[name] = GetColorForSetting(oreEntityColors[name], entityColorModeSetting)
end
for _, name in pairs(oreList) do
    oreMapColors[name] = Utils.DeepCopy(data.raw["resource"][name].map_color)
    oreMapColors[name] = GetColorForSetting(oreMapColors[name], mapColorModeSetting)
end

for _, oreName in pairs(oreList) do
    local oreEntityColor = oreEntityColors[oreName]
    local oreMapColor = oreMapColors[oreName]
    local oreProto = data.raw["resource"][oreName]

    if entityColorModeSetting ~= "vanilla" then
        local oreSheet = oreProto.stages.sheet
        oreSheet.filename = Constants.AssetModName .. "/graphics/dull-ore.png"
        oreSheet.tint = oreEntityColor
        oreSheet.hr_version.filename = Constants.AssetModName .. "/graphics/hr-dull-ore.png"
        oreSheet.hr_version.tint = oreEntityColor
        oreProto.stages_effect = nil
    end

    if mapColorModeSetting ~= "vanilla" then
        oreProto.map_color = oreMapColor
        if mapColorModeSetting == "invisible" then
            oreProto.map_grid = false
        else
            oreProto.map_grid = true
        end
    end

    if not mapHighlightingSetting then
        oreProto.resource_patch_search_radius = false
    end
end
