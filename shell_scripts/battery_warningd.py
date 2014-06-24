"""
Battery-level warning script.

A daemonized script that emits warnings whenever the computer's battery hits
critical levels (high when charging, low when discharging).
"""

import os
import time

BATTERY_CHECK_INTERVAL = 5 # seconds between each poll
LOWER_LEVELS = [5, 10, 15, 20] # lower critical levels
UPPER_LEVELS = [90, 95, 97] # higher critical levels

def battery_checker():
	"""
	Emits a warning whenever the computer's battery hits critical levels.
	"""

	prev_level = -1
	while True:
		curr_level = battery_level()
		if int(curr_level) != prev_level:
			if file_contents("status") == "Charging":
				if curr_level in UPPER_LEVELS:
					warning("overcharging", curr_level)
			elif curr_level in LOWER_LEVELS:
					warning("low", curr_level)

			prev_level = int(curr_level)

		time.sleep(BATTERY_CHECK_INTERVAL)

def warning(msg, level):
	"""
	Output a warning about the current battery level.

	Args:
		msg : (str) The battery-status specifier to output.
		level : (int) The current battery level.
	"""

	os.system("notify-send -u critical 'Battery %s' 'at %s%%'" % (msg, level))
	os.system("play ../res/battery_warning.wav")

def battery_level():
	"""
	Get the current battery level.

	Return
		(int) The battery level.
	"""

	return (int(file_contents("energy_now")) * 100 /
		int(file_contents("energy_full")))

def file_contents(path):
	"""
	Return the contents of a battery status file.

	Args:
		path : (str) The path to a file with one line.

	Return:
		(str) The file's contents, with any newlines removed.
	"""

	BATTERY_DIR = "/sys/class/power_supply/BAT0"
	with open("/sys/class/power_supply/BAT0/%s" % path) as obj:
		return obj.read().rstrip("\n")

if __name__ == "__main__":
	battery_checker()
