# This script resolves the issue of suspend/sleep hanging on MediaTek wifi cards:
# https://community.frame.work/t/amd-350-debian-13-trixie-rc3-failing-to-suspend-wifi/73466/6
# Place in: /usr/lib/systemd/system-sleep/mediatek-suspend-fix.sh 
# and run sudo chmod +x to ensure the script is executable


#!/bin/bash
case in ${1} in
    pre)
    # Uncommon line to choose for either mt7921 or mt7925
    #rmmod mt7921e mt7921-common mt7921x-lib mt76-connac-lib mt76
    #rmmod mt7925e mt7925-common mt792x-lib mt76-connac-lib mt76
    ;;
    post)
    #modprobe mt7921e
    #modprobe mt7925e
    ;;
esac
