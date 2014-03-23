#! /usr/bin/zsh

#    Description:
#       Quasi-daemonized script that checks the battery level and plays a
#       sound, then flashes a warning message if it reaches critical levels.
#
#    Use:
#       chmod +x batteryWarning.zsh

audio_file_path="/usr/bin/sounds-882-solemn.wav"  # sound to be played
battery_level_low=(5 10 15 20)
battery_level_high=(90 95 97)
loop_interval=5     # seconds between battery level checks

battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`
battery_status=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 |\
	grep state)     # whether charging or discharging

# play a sound and flash a warning message with the current battery level and
# one argument message
send_warning(){
	notify-send -u critical "Battery $1" "Battery level is ${battery_level}%!"
	play $audio_file_path
}

# echo "true" if $battery_level is equal to any of $*; echo "false" if not
battery_level_critical(){
	local battery_critical=false
	for level in ${*:1}; do
		if [ $battery_level -eq $level ]; then
			battery_critical=true
			break
		fi
	done
	echo $battery_critical
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
		printf "Different: %d" $battery_level
		if [ "$(battery_level_critical ${battery_level_low[@]})" = "true" ] \
			&& [ ${battery_status:25} = "discharging" ]; then
			send_warning "low"

		else
			if [ "$(battery_level_critical ${battery_level_high[@]})" = \
				"true" ] && [ "${battery_status:25}" = "charging" ]; then
				send_warning "overcharging"
			fi
		fi
	fi

	sleep $loop_interval
done
