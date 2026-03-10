#!/usr/bin/env bash

# This script is used to change the colorscheme and icons of the Plasma desktop environment. 
# I created it since I want the system theme switch to respect the icons and window decorations, which dont use the standard system default while also using the system theme switcher. 
# I have symylinked it to ~/.config/autostart-scripts/ tomake it run at startup, but it also runs on theme switch.

sleep 3
/usr/lib/plasma-changeicons Tela
/usr/bin/kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key library "org.kde.kwin.aurorae.v2"
/usr/bin/kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key theme "__aurorae__svg__WhiteSur-Sharp-dark"
/usr/lib/qt6/bin/qdbus org.kde.KWin /KWin reconfigure
