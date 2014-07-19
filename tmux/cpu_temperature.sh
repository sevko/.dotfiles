#! /bin/bash

# Description:
#   Prints the current temperature of the computer's CPU. Depends on the `acpi`
#   utility.
#
# Use:
#   ./cpu_temperature.sh

main(){
	local temp="$(acpi -t | grep -oP "[^ ]*(?= degrees)")"
	printf "#[bg=colour4,bold] CPU:#[nobold] %s° #[fg=colour232]" ${temp%%.*}
}

main
