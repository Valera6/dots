#!/bin/sh
# normally the following variables solve the problem for all (plus the two scripts). But the `swaymsg` things don't keep the env information. I probably could do add `/bin/env sh` to them, but just adding only the needed varibles also works.
#QT_QPA_PLATFORMTHEME=flatpak
#GTK_USE_PORTAL=1
#export GDK_DEBUG=portals


swaymsg "workspace 4, exec alacritty && todo"
swaymsg "workspace 2, exec google-chrome-stable" #--enable-features=UseOzonePlatform --ozone-platform=wayland"
swaymsg "workspace 3, exec QT_QPA_PLATFORMTHEME=flatpak telegram-desktop &"
# the XDG_CURRENT_DESKTOP makes it try to use `kdialog` app. There is no kdialog app, so it's tricked into executing my script in the $PATH, `~/s/help_scripts/kdialog`. The script then redirects it into the file picker solution in `~/.config/nnn/termfilechooser.sh`
swaymsg "exec GTK_USE_PORTAL=1 QT_QPA_PLATFORMTHEME=flatpak XDG_CURRENT_DESKTOP=KDE discord &" # --enable-features=UseOzonePlatform --ozone-platform=wayland &"
swaymsg "workspace 1, exec alacritty"

#TODO: switch to running it in a minimzed system tray.
sleep 30
# discord had time to load and refresh notifs. Now kill the greedy beast.
swaymsg exec "~/.config/sway/discord_toggle.sh"
