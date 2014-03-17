#! /usr/bin/zsh

#    Description:
#       Quasi-daemonized script that checks the battery level and plays a
#       sound, then flashes a warning message if it reaches critical levels.
#
#    Use:
#       chmod +x batteryWarning.zsh

audioFilePath="/usr/bin/sounds-882-solemn.wav"  # sound to be played
battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`
battery_status=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 |\
	grep state)     # whether charging or discharging

# play a sound and flash a warning message with the current battery level and
# one argument message
send_warning(){
	notify-send -u critical "Battery $1" "Battery level is ${battery_level}%!"
	play $audioFilePath
}

# daemon loop running at five-second intervals
while true; do

	# update all battery variables
	old_battery_level=$battery_level
	battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`
	battery_status=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 |\
		grep state)

	# flash warning if battery level hits critical levels
	if [ $old_battery_level -ne $battery_level ]; then
		echo "old"
		if [ $battery_level -eq 20 -o $battery_level -eq 15 \
			-o $battery_level -eq 10 -o $battery_level -eq 5 ] \
			&& [ ${battery_status:25} = "discharging" ]; then
			send_warning "low"

		else if [ $battery_level -eq 90 -o $battery_level -eq 95 \
			-o $battery_level -eq 98 -o $battery_level -eq 99 ] \
			&& [ "${battery_status:25}" = "charging" ]; then
			send_warning "overcharging"
		fi
		fi
	fi

	echo $battery_level
	sleep 5
done
