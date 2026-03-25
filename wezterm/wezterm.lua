local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Font
config.font = wezterm.font('MesloLGS Nerd Font Mono')
config.font_size = 15.0

-- coolnight color scheme
config.colors = {
  foreground = '#CBE0F0',
  background = '#011423',
  cursor_bg = '#47FF9C',
  cursor_fg = '#011423',
  cursor_border = '#47FF9C',
  ansi = {
    '#214969', -- black
    '#E52E2E', -- red
    '#44FFB1', -- green
    '#FFE073', -- yellow
    '#0FC5ED', -- blue
    '#a277ff', -- magenta
    '#24EAF7', -- cyan
    '#24EAF7', -- white
  },
  brights = {
    '#214969', -- black
    '#E52E2E', -- red
    '#44FFB1', -- green
    '#FFE073', -- yellow
    '#A277FF', -- blue
    '#a277ff', -- magenta
    '#24EAF7', -- cyan
    '#24EAF7', -- white
  },
}

-- Window
config.window_padding = { left = 14, right = 14, top = 14, bottom = 14 }
config.window_background_opacity = 0.8
config.window_decorations = 'RESIZE'
config.initial_cols = 120
config.initial_rows = 40

-- macOS-specific: blur
if wezterm.target_triple:find('darwin') then
  config.macos_window_background_blur = 20
end

-- Term
config.term = 'xterm-256color'

-- Keybindings
config.keys = {
  { key = 'F11', mods = '', action = wezterm.action.ToggleFullScreen },
}

return config
