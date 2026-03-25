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
  split = '#24EAF7',
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

-- Dim inactive panes
config.inactive_pane_hsb = { saturation = 0.6, brightness = 0.4 }

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

-- Seamless nvim/pane navigation (mirrors vim-tmux-navigator)
-- If nvim is the foreground process, forward the key; otherwise move the pane
local function is_vim(pane)
  local proc = pane:get_foreground_process_info()
  local name = proc and proc.name or ''
  return name == 'nvim' or name == 'vim'
end

local nav_dirs = { h = 'Left', j = 'Down', k = 'Up', l = 'Right' }

local function nav(key)
  return {
    key = key,
    mods = 'CTRL',
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        win:perform_action({ SendKey = { key = key, mods = 'CTRL' } }, pane)
      else
        win:perform_action({ ActivatePaneDirection = nav_dirs[key] }, pane)
      end
    end),
  }
end

-- Leader key (tmux-style: Ctrl+B)
config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 }

-- Keybindings
config.keys = {
  { key = 'F11', mods = '', action = wezterm.action.ToggleFullScreen },

  -- Pane navigation (seamless with nvim, like vim-tmux-navigator)
  nav('h'), nav('j'), nav('k'), nav('l'),

  -- Panes
  { key = '|', mods = 'LEADER', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-', mods = 'LEADER', action = wezterm.action.SplitVertical   { domain = 'CurrentPaneDomain' } },
  { key = 'z', mods = 'LEADER', action = wezterm.action.TogglePaneZoomState },
  { key = 'm', mods = 'LEADER', action = wezterm.action.TogglePaneZoomState },
  { key = 'x', mods = 'LEADER', action = wezterm.action.CloseCurrentPane { confirm = true } },

  -- Tabs (windows in tmux terms)
  { key = 'c', mods = 'LEADER', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = 'n', mods = 'LEADER', action = wezterm.action.ActivateTabRelative(1) },
  { key = 'p', mods = 'LEADER', action = wezterm.action.ActivateTabRelative(-1) },

  -- Jump to tab by number (like tmux <leader>0-9)
  { key = '1', mods = 'LEADER', action = wezterm.action.ActivateTab(0) },
  { key = '2', mods = 'LEADER', action = wezterm.action.ActivateTab(1) },
  { key = '3', mods = 'LEADER', action = wezterm.action.ActivateTab(2) },
  { key = '4', mods = 'LEADER', action = wezterm.action.ActivateTab(3) },
  { key = '5', mods = 'LEADER', action = wezterm.action.ActivateTab(4) },
  { key = '6', mods = 'LEADER', action = wezterm.action.ActivateTab(5) },
  { key = '7', mods = 'LEADER', action = wezterm.action.ActivateTab(6) },
  { key = '8', mods = 'LEADER', action = wezterm.action.ActivateTab(7) },
  { key = '9', mods = 'LEADER', action = wezterm.action.ActivateTab(8) },

  -- Copy mode
  { key = '[', mods = 'LEADER', action = wezterm.action.ActivateCopyMode },
}

return config
