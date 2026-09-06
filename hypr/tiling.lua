-- Make consistent with Omarchy
-- Uses the `mainMod`, `terminal`, `fileManager` globals set in hyprland.lua before this is required.

-- Close windows
hl.bind(mainMod .. " + W", hl.dsp.window.close(), { description = "Close window" })
-- hl.bind("CTRL + ALT + DELETE", hl.dsp.exec_cmd("omarchy-hyprland-window-close-all"), { description = "Close all windows" })

-- Control tiling
-- hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"), { description = "Toggle window split" }) -- Not needed - already in hyprland.lua
-- hl.bind(mainMod .. " + P", hl.dsp.window.pseudo(), { description = "Pseudo window" }) -- dwindle -- Not needed - already in hyprland.lua
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle window floating/tiling" })
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }), { description = "Full screen" })
-- hl.bind(mainMod .. " + CTRL + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 2 }), { description = "Tiled full screen" }) -- Come back to this
hl.bind(mainMod .. " + ALT + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }), { description = "Full width" })
-- hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("omarchy-hyprland-window-pop"), { description = "Pop window out (float & pin)" }) -- Come back to this
-- hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("omarchy-hyprland-workspace-layout-toggle"), { description = "Toggle workspace layout" }) -- Come back to this

-- Move focus with mainMod + arrow keys
-- Not needed - already in hyprland.lua
-- hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }),  { description = "Move window focus left" })
-- hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }), { description = "Move window focus right" })
-- hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }),    { description = "Move window focus up" })
-- hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }),  { description = "Move window focus down" })

-- Switch workspaces with mainMod + [1-9; 0] -- Not needed - already in hyprland.lua
-- for i = 1, 10 do
--     hl.bind(mainMod .. " + code:" .. (9 + i), hl.dsp.focus({ workspace = i }), { description = "Switch to workspace " .. i })
-- end

-- Move active window to a workspace with mainMod + SHIFT + [1-9; 0] -- Not needed - already in hyprland.lua
-- for i = 1, 10 do
--     hl.bind(mainMod .. " + SHIFT + code:" .. (9 + i), hl.dsp.window.move({ workspace = i }), { description = "Move window to workspace " .. i })
-- end

-- Control scratchpad -- Not needed - already in hyprland.lua
-- hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("scratchpad"), { description = "Toggle scratchpad" })
