#! /bin/bash

# Description:
#   cron'd script that initializes the battery_warningd daemon if it
#   isn't currently running.
#
# Use:
#   # add the following to your crontab
#   * * * * * ~/.dotfiles/shell_scripts/battery_warning_init.sh

init_battery_warningd(){
	local processes="$(ps -ef)"
	local process_regex="python [^ ]*battery_warningd\.py"

	if [[ ! "$processes" =~ $process_regex ]]; then
		export DISPLAY=:0.0
		export XAUTHORITY=~/.Xauthority
		python ~/.dotfiles/shell_scripts/battery_warningd.py &
	fi
}

init_battery_warningd
