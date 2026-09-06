-- Uses the `mainMod`, `terminal`, `fileManager` globals set in hyprland.lua before this is required.

-- Move windows within tiling layout
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))

-- Screenshot
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd([[grim -g "$(slurp)" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png]]))

-- Application bindings
-- hl.bind("SUPER + ALT + RETURN", hl.dsp.exec_cmd([[uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" tmux new]]), { description = "Tmux" })
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal)) -- omarchy default: uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)"

hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("firefox")) -- omarchy default: omarchy-launch-browser
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd(fileManager)) -- omarchy default: uwsm-app -- nautilus --new-window
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd("obsidian")) -- omarchy default: omarchy-launch-or-focus ^obsidian$ "uwsm-app -- obsidian -disable-gpu --enable-wayland-ime"
-- hl.bind("SUPER + SHIFT + ALT + B", hl.dsp.exec_cmd("omarchy-launch-browser --private"), { description = "Browser (private)" })
-- hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("omarchy-launch-or-focus spotify"), { description = "Music" })
-- hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("omarchy-launch-editor"), { description = "Editor" })
-- hl.bind("SUPER + SHIFT + T", hl.dsp.exec_cmd("omarchy-launch-tui btop"), { description = "Activity" })
-- hl.bind("SUPER + SHIFT + D", hl.dsp.exec_cmd("omarchy-launch-tui lazydocker"), { description = "Docker" })
-- hl.bind("SUPER + SHIFT + G", hl.dsp.exec_cmd([[omarchy-launch-or-focus ^signal$ "uwsm-app -- signal-desktop"]]), { description = "Signal" })
-- hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("uwsm-app -- typora --enable-wayland-ime"), { description = "Typora" })

-- Web apps
-- hl.bind("SUPER + SHIFT + A", hl.dsp.exec_cmd([[omarchy-launch-webapp "https://chatgpt.com"]]), { description = "ChatGPT" })
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd([[firefox "https://github.com"]])) -- omarchy default: omarchy-launch-webapp "https://github.com"
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd([[firefox "https://app.slack.com/client/T6SPCTC8L/C08NT9310RE"]])) -- omarchy default: omarchy-launch-webapp "https://app.slack.com/client/T6SPCTC8L/C08NT9310RE"
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd([[firefox "https://gmail.com"]])) -- omarchy default: omarchy-launch-webapp "https://gmail.com"
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd([[firefox "https://calendar.google.com/calendar"]])) -- omarchy default: omarchy-launch-webapp "https://calendar.google.com/calendar"
hl.bind(mainMod .. " + SHIFT + Y", hl.dsp.exec_cmd([[firefox "https://youtube.com/"]])) -- omarchy default: omarchy-launch-webapp "https://youtube.com/"
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd([[firefox "https://meet.google.com"]])) -- omarchy default: omarchy-launch-webapp "https://meet.google.com"
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd([[firefox "https://notion.so/"]])) -- omarchy default: omarchy-launch-webapp "https://notion.so/"


-- Overwrite existing bindings, like putting Omarchy Menu on Super + Space
-- hl.unbind("SUPER + SPACE")
-- hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("omarchy-menu"), { description = "Omarchy menu" })
