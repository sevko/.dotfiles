#! /usr/bin/zsh

# Description:
#   cron'd script that initializes the battery_warningd daemon if it
#   isn't currently running.
#
# Use:
#   chmod +x battery_warning_init.py
#
#   # and add the following to your crontab
#   * * * * * ~/.dotfiles/batteryWarningInit.zsh

if [ "$(ps -e | grep 'batteryWarningd')" = "" ]; then
	export DISPLAY=:0.0 && export XAUTHORITY=~/.Xauthority && \
		python ~/.dotfiles/shell_scripts/battery_warningd.py &
fi
