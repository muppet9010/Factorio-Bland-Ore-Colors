local Constants = require("constants")


local colorModeSetting = settings.startup["color-mode"].value
if colorModeSetting == "vanilla" then
    return
end


local oreList = {"iron-ore", "copper-ore", "coal", "stone", "uranium-ore"}
local oreAlpha = 0.8
local oresMapColor = {}
for _, name in pairs(oreList) do
    oresMapColor[name] = data.raw["resource"][name].map_color
    oresMapColor[name].a = oreAlpha
end


if colorModeSetting == "bland" then
    for ore, tint in pairs(oresMapColor) do
        local difR = (0.5 - tint.r) / 4 * 3
        oresMapColor[ore].r = tint.r + difR
        local difG = (0.5 - tint.g) / 4 * 3
        oresMapColor[ore].g = tint.g + difG
        local difB = (0.5 - tint.b) / 4 * 3
        oresMapColor[ore].b = tint.b + difB
    end
elseif colorModeSetting == "grey" then
    for ore in pairs(oresMapColor) do
        oresMapColor[ore] = {r=0.3, g=0.3, b=0.3, a=0.8}
    end
elseif colorModeSetting == "invisible" then
    for ore in pairs(oresMapColor) do
        oresMapColor[ore] = {r=0, g=0, b=0, a=0}
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
