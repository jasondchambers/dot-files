#!/usr/bin/env bash
# WiFi selector using nmcli + wofi

# Toggle wifi on/off if called with --toggle
if [[ "$1" == "--toggle" ]]; then
    state=$(nmcli radio wifi)
    if [[ "$state" == "enabled" ]]; then
        nmcli radio wifi off
    else
        nmcli radio wifi on
    fi
    exit 0
fi

# Ensure wifi is on
nmcli radio wifi on

# Scan for networks
nmcli device wifi rescan 2>/dev/null

# Build list: connected network first, then others
connected=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
networks=$(nmcli -t -f ssid,signal,security dev wifi list 2>/dev/null \
    | sort -t: -k2 -rn \
    | awk -F: '!seen[$1]++ && $1 != ""' \
    | while IFS=: read -r ssid signal security; do
        lock=""
        [[ "$security" != "--" ]] && lock=" "
        bars="▂▄▆█"
        if   (( signal >= 75 )); then bar="$bars"
        elif (( signal >= 50 )); then bar="${bars:0:3}"
        elif (( signal >= 25 )); then bar="${bars:0:2}"
        else                          bar="${bars:0:1}"
        fi
        active=""
        [[ "$ssid" == "$connected" ]] && active=" ✓"
        echo "${bar}${lock} ${ssid}${active}"
    done)

[[ -z "$networks" ]] && notify-send "WiFi" "No networks found" && exit 1

# Show picker
chosen=$(echo "$networks" | wofi --dmenu --prompt "WiFi" --width 400 --height 300)
[[ -z "$chosen" ]] && exit 0

# Extract SSID (strip signal bar prefix and lock icon)
ssid=$(echo "$chosen" | sed 's/^[▂▄▆█]* *\( *\)\? *//' | sed 's/ *✓$//')

# Already connected?
if [[ "$ssid" == "$connected" ]]; then
    choice=$(printf "Disconnect\nCancel" | wofi --dmenu --prompt "$ssid" --width 300 --height 150)
    [[ "$choice" == "Disconnect" ]] && nmcli device disconnect "$(nmcli -t -f device,type dev | grep wifi | cut -d: -f1 | head -1)"
    exit 0
fi

# Connect (use saved profile if exists, otherwise prompt for password)
if nmcli connection show "$ssid" &>/dev/null; then
    nmcli connection up "$ssid" && notify-send "WiFi" "Connected to $ssid"
else
    password=$(wofi --dmenu --prompt "Password for $ssid" --password --width 400 --height 80)
    if [[ -n "$password" ]]; then
        nmcli device wifi connect "$ssid" password "$password" \
            && notify-send "WiFi" "Connected to $ssid" \
            || notify-send "WiFi" "Failed to connect to $ssid"
    fi
fi
