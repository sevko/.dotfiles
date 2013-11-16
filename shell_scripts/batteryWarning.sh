#! /bin/bash

#	Description:
#		Battery warning script that plays a sound and flashes a warning
#		message when one's battery falls below/exceeds certain levels.
#		Note: modify audioFilePath with an appropriate file path.
#	
#	Use:
#		chmod +x batteryWarning.sh
#
#		#and add the following to your crontab
#		* * * * * export DISPLAY=:0.0 && export XAUTHORITY=~/.Xauthority && ~/.dotfiles/batteryWarning.sh 
	
audioFilePath="/usr/bin/sounds-882-solemn.wav"

battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`
batt=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state)
file=~/.batteryWarningTempFile.txt

if [ ! $battery_level -eq `cat $file` ] 
then 
	if [ $battery_level -eq 20 -o $battery_level -eq 15 -o $battery_level -eq 10 -o $battery_level -eq 5 ] && [ ${batt:10} == "discharging" ]  
	then
    	notify-send -u critical "Battery low" "Battery level is ${battery_level}%!"
    	play $audioFilePath

	else if [ $battery_level -eq 90 -o $battery_level -eq 95 -o $battery_level -eq 98 -o $battery_level -eq 99 ] && [ ${batt:10} == "charging" ]
	then
    	notify-send -u critical "Battery overcharging" "Battery level is ${battery_level}%!"
    	play $audioFilePath
	fi
	fi
	echo $battery_level > $file
fi
