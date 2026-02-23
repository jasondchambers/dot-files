-- These bindings are taken from my Omarchy keybindings to ensure where
-- possible, a consistent experience is maintained between my machines.

--bindd = SUPER, RETURN, Terminal, exec, uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)"
hs.hotkey.bind({"alt"}, "return", function()
    hs.application.launchOrFocus("Alacritty")
end)

--bindd = SUPER SHIFT, F, File manager, exec, uwsm-app -- nautilus --new-window
hs.hotkey.bind({"alt", "shift"}, "f", function()
    hs.application.launchOrFocus("finder")
end)

--bindd = SUPER SHIFT, B, Browser, exec, omarchy-launch-browser
hs.hotkey.bind({"alt", "shift"}, "b", function()
    hs.application.launchOrFocus("Safari")
end)

--bindd = SUPER SHIFT, T, Activity, exec, omarchy-launch-tui btop
hs.hotkey.bind({"alt", "shift"}, "t", function()
    local command_to_run = "btop"
    local script = 'tell app "Terminal" to do script "' .. command_to_run .. '"'
    
    -- Execute the AppleScript using the osascript command line utility
    hs.execute('osascript -e \'' .. script .. '\'')
end)

--bindd = SUPER SHIFT, D, Docker, exec, omarchy-launch-tui lazydocker
hs.hotkey.bind({"alt", "shift"}, "d", function()
    local command_to_run = "lazydocker"
    local script = 'tell app "Terminal" to do script "' .. command_to_run .. '"'
    
    -- Execute the AppleScript using the osascript command line utility
    hs.execute('osascript -e \'' .. script .. '\'')
end)

--bindd = SUPER SHIFT, O, Obsidian, exec, omarchy-launch-or-focus ^obsidian$ "uwsm-app -- obsidian -disable-gpu --enable-wayland-ime"
hs.hotkey.bind({"alt", "shift"}, "o", function()
    hs.application.launchOrFocus("Obsidian")
end)

--bindd = SUPER SHIFT, W, Typora, exec, uwsm-app -- typora --enable-wayland-ime
hs.hotkey.bind({"alt", "shift"}, "w", function()
    hs.application.launchOrFocus("Typora")
end)

--bindd = SUPER SHIFT, SLASH, Passwords, exec, uwsm-app -- 1password
hs.hotkey.bind({"alt", "shift"}, "/", function()
    hs.application.launchOrFocus("1Password")
end)

--bindd = SUPER SHIFT, A, ChatGPT, exec, omarchy-launch-webapp "https://chatgpt.com"
hs.hotkey.bind({"alt", "shift"}, "a", function()
    hs.execute("open 'https://chatgpt.com'")
end)

--bindd = SUPER SHIFT, G, Github, exec, omarchy-launch-webapp "https://github.com"
hs.hotkey.bind({"alt", "shift"}, "g", function()
    hs.execute("open 'https://github.com'")
end)

--bindd = SUPER SHIFT, S, Slack, exec, omarchy-launch-webapp "https://app.slack.com/client/T6SPCTC8L/C08NT9310RE"
hs.hotkey.bind({"alt", "shift"}, "s", function()
    hs.application.launchOrFocus("Slack")
end)

--bindd = SUPER SHIFT, E, Email, exec, omarchy-launch-webapp "https://gmail.com"
hs.hotkey.bind({"alt", "shift"}, "e", function()
    hs.execute("open 'https://gmail.com'")
end)

--bindd = SUPER SHIFT, C, Calendar, exec, omarchy-launch-webapp "https://calendar.google.com/calendar"
hs.hotkey.bind({"alt", "shift"}, "c", function()
    hs.execute("open 'https://calendar.google.com/calendar'")
end)

--bindd = SUPER SHIFT, Y, YouTube, exec, omarchy-launch-webapp "https://youtube.com/"
hs.hotkey.bind({"alt", "shift"}, "y", function()
    hs.execute("open 'https://youtube.com/'")
end)

--bindd = SUPER SHIFT, M, Meet, exec, omarchy-launch-webapp "https://meet.google.com"
hs.hotkey.bind({"alt", "shift"}, "m", function()
    hs.execute("open 'https://meet.google.com'")
end)

--bindd = SUPER SHIFT ALT, G, WhatsApp, exec, omarchy-launch-webapp "https://web.whatsapp.com/"
hs.hotkey.bind({"alt", "shift"}, "g", function()
    hs.execute("open 'https://web.whatsapp.com/'")
end)

--bindd = SUPER SHIFT, N, Notion, exec, omarchy-launch-webapp "https://notion.so/"
hs.hotkey.bind({"alt", "shift"}, "n", function()
    hs.application.launchOrFocus("Notion")
end)





hs.hotkey.bind({"alt"}, "w", function()    local win = hs.window.focusedWindow()
    if win then
        win:close()
    end
end)

hs.hotkey.bind({"alt"}, "f", function()
    local win = hs.window.focusedWindow()
    if win then
        win:toggleFullScreen()
    end
end)
  

  

  