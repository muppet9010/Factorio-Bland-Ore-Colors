local Constants = require("constants")
local Utils = require("utility/utils")
--local Logging = require("utility/logging")

local function GetColorForSetting(oreColor, settingValue)
    if settingValue == "vanilla" then
        return oreColor
    elseif settingValue == "dull" then
        oreColor[4] = 0.8
    elseif settingValue == "bland" then
        local function CalcBlandColor(oreColor)
            local dif = (0.5 - oreColor) / 4 * 3
            return oreColor + dif
        end
        oreColor = {
            CalcBlandColor(oreColor[1] or oreColor.r),
            CalcBlandColor(oreColor[2] or oreColor.g),
            CalcBlandColor(oreColor[3] or oreColor.b),
            0.8
        }
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

local ore_box = {{-0.5, -0.5}, {0.5, 0.5}}
local oreList = {"coal", "stone"}
local oreEntityColors, oreMapColors = {}, {}

for name, ore in pairs(data.raw["resource"]) do
    if string.match(name,"-ore%d*") ~= nil then
        if string.match(name, "infinite") == nil then
            if table_compare(ore.selection_box, ore_box) then
                table.insert(oreList, name)
            end
        end
    end
end

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
        if oreSheet.hr_version ~= nil then
            oreSheet.hr_version.filename = Constants.AssetModName .. "/graphics/hr-dull-ore.png"
            oreSheet.hr_version.tint = oreEntityColor
        end
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
