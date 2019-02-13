
local function RechartAllForces()
    for _, force in pairs(game.forces) do
        force.rechart()
    end
end


local function OnInit()
    RechartAllForces()
end


local function OnConfigurationChanged()
    RechartAllForces()
end


local function OnSettingChanged(event)
    local settingName = event.setting
    if settingName == "color-mode" then
        RechartAllForces()
    end
end


script.on_init(OnInit)
script.on_configuration_changed(OnConfigurationChanged)
script.on_event(defines.events.on_runtime_mod_setting_changed, OnSettingChanged)
