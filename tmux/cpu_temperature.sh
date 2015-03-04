#! /bin/bash

# Description:
#   Prints the current temperature of the computer's CPU. Depends on the `acpi`
#   utility.
#
# Use:
#   ./cpu_temperature.sh

main(){
	local temp="$(acpi -t | grep -oP "[^ ]*(?= degrees)")"
	temp=${temp%%.*}
	local bgcolor=4
	local fgcolor=232

	if [ $temp -gt 100 ]; then
		bgcolor=196
		fgcolor=255
	elif [ $temp -gt 85 ]; then
		bgcolor=9
	elif [ $temp -gt 70 ]; then
		bgcolor=214
	fi

	printf "#[bg=colour$bgcolor,fg=colour$fgcolor,bold]#[nobold] %s° " $temp
}

main
echo $bgcolor
