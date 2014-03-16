#! /bin/bash

#   Description:
#       tmuxBatteryStatus.sh echoes a string indicating the current battery
#       level, and an energy symbol if the battery's charging. Used by my tmux
#       statusline.
#
#   Use:
#       chmod +x tmuxBatteryStatus.sh && ./tmuxBatteryStatus.sh

batt_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`
batt_status1=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state)
batt_status=${batt_status1:10}

batt_icon=""

if [ $batt_status == "charging" ]
then
	batt_icon="⚡"
fi

echo "$batt_level% $batt_icon"
