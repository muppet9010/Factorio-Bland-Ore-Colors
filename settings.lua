data:extend(
    {
        {
            name = "bland_ore_colors-entity_color_mode",
            type = "string-setting",
            default_value = "dull",
            allowed_values = {"dull", "bland", "grey", "invisible", "vanilla"},
            setting_type = "startup",
            order = "1001"
        },
        {
            name = "bland_ore_colors-map_color_mode",
            type = "string-setting",
            default_value = "dull",
            allowed_values = {"dull", "bland", "grey", "invisible", "vanilla"},
            setting_type = "startup",
            order = "1002"
        },
        {
            name = "bland_ore_colors-enable_map_highlighting",
            type = "bool-setting",
            default_value = "true",
            setting_type = "startup",
            order = "1003"
        }
    }
)
