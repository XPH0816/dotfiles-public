local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"

config.initial_cols = 160

config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font",
	"Hack Nerd Font",
	"CaskaydiaCove Nerd Font",
	"JetBrains Mono",
})

return config
