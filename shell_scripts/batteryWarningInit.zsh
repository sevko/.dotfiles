#! /usr/bin/zsh

#   Description:
#       cron'd script that initializes the batteryWarningd.zsh daemon if it
#       isn't currently running.
#
#   Use:
#       chmod +x batteryWarningInit.zsh
#
#       # and add the following to your crontab
#       * * * * * ~/.dotfiles/batteryWarningInit.zsh

if [ "$(ps -e | grep 'batteryWarningd')" = "" ]; then
	export DISPLAY=:0.0 && export XAUTHORITY=~/.Xauthority && \
		~/.dotfiles/shell_scripts/batteryWarningd.zsh
fi
