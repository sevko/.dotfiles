"""
Battery-level warning script.

A daemonized script that emits warnings whenever the computer's battery hits
critical levels (high when charging, low when discharging).
"""

import json
import os
import pyglet
import time

config = {} # see `load_config()`

def battery_checker():
	"""
	Emits a warning whenever the computer's battery hits critical levels.
	"""

	pyglet.resource.path = [
		os.path.expanduser("~/.dotfiles/res/battery_warning/")
	]
	pyglet.resource.reindex()

	prev_level = -1
	while True:
		curr_level = battery_level()
		if int(curr_level) != prev_level:
			if file_contents("status") == "Charging":
				if curr_level in config["upper_levels"]:
					warning("overcharging", curr_level)
			elif curr_level in config["lower_levels"]:
				warning("low", curr_level)

			prev_level = int(curr_level)

		time.sleep(config["interval"])

def warning(msg, level):
	"""
	Output a warning about the current battery level.

	Args:
		msg : (str) The battery-status specifier to output.
		level : (int) The current battery level.
	"""

	pyglet.resource.media("warning.wav").play()
	os.system(
		"xmessage -default Acknowledge -button Acknowledge -center "
		"'Battery %s' 'at %s%%'" % (msg, level))

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

	battery_dir = "/sys/class/power_supply/BAT0/"
	with open("%s%s" % (battery_dir, path)) as obj:
		return obj.read().rstrip("\n")

def load_config():
	"""
	Load the script's settings.

	The script stores configurable setting values in a JSON file
	(`res/battery_warning/config.json`)
	"""

	global config

	json_config_file = os.path.expanduser(
		"~/.dotfiles/res/battery_warning/config.json")
	with open(json_config_file) as setup_file:
		config = json.loads(setup_file.read())

if __name__ == "__main__":
	load_config()
	battery_checker()
