local Constants = require("constants")

local colorModeSetting = settings.startup["color-mode"].value
if colorModeSetting == "vanilla" then
    return
end

local oreList = {"iron-ore", "copper-ore", "coal", "stone", "uranium-ore"}
local oresMapColor = {}
for _, name in pairs(oreList) do
    oresMapColor[name] = data.raw["resource"][name].map_color
end

if colorModeSetting == "dull" then
    for ore in pairs(oresMapColor) do
        oresMapColor[ore][4] = 0.8
    end
elseif colorModeSetting == "bland" then
    for ore, tint in pairs(oresMapColor) do
        local difR = (0.5 - tint[1]) / 4 * 3
        oresMapColor[ore][1] = tint[1] + difR
        local difG = (0.5 - tint[2]) / 4 * 3
        oresMapColor[ore][2] = tint[2] + difG
        local difB = (0.5 - tint[3]) / 4 * 3
        oresMapColor[ore][3] = tint[3] + difB
        oresMapColor[ore][4] = 0.8
    end
elseif colorModeSetting == "grey" then
    for ore in pairs(oresMapColor) do
        oresMapColor[ore] = {0.3, 0.3, 0.3, 0.8}
    end
elseif colorModeSetting == "invisible" then
    for ore in pairs(oresMapColor) do
        oresMapColor[ore] = {0, 0, 0, 0}
    end
end

for ore, tint in pairs(oresMapColor) do
    local oreProto = data.raw["resource"][ore]
    oreProto.map_color = tint
    local oreSheet = oreProto.stages.sheet
    oreSheet.filename = Constants.AssetModName .. "/graphics/dull-ore.png"
    oreSheet.tint = tint
    oreSheet.hr_version.filename = Constants.AssetModName .. "/graphics/hr-dull-ore.png"
    oreSheet.hr_version.tint = tint
    oreProto.stages_effect = nil
end
