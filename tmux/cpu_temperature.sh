#! /bin/bash

# Description:
#   Prints the current temperature of the computer's CPU. Depends on the `acpi`
#   utility.
#
# Use:
#   ./cpu_temperature.sh

main(){
	printf "#[bg=colour4,bold] CPU:#[nobold] %s° #[fg=colour232]" \
		"$(acpi -t | grep -oP "[^ ]*(?= degrees)")"
}

main
