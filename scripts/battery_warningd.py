#! /usr/bin/env python

"""
# description
Perpetually polls the computer's battery, emitting warnings when it's
discharging/charging and hits respectively low/high levels. The script should
be kicked off on boot, which may be solved by adding a line to
`/etc/rc.local`. It's configured in a Yaml file
(`../res/battery_warning/config.yml`), which contains the following keys:

  * interval: the number of seconds between polls
  * lower: an array of battery-levels to check against when the computer is
    discharging.
  * upper: an array of battery-levels to check against when the computer is
    charging.
  * sound: the path to the `.wav` sound file the script should play on warning.

During every poll, if the current battery level is compared in either
`lower`/`upper` (depending on whether the battery's charging or discharging), a
warning will be emitted. Note that this will only occur *once* per battery
level -- no matter how small the `interval` -- before it changes to another .

# dependencies

  * `pyaml`: `[sudo] pip install pyaml`
  * `upower`: `[sudo] apt-get install upower`
  * `xmessage`: `[sudo] apt-get install upower`
"""

import os
import re
import subprocess
import time
import yaml
import logging

def _battery_checker(config):
	"""
	Continuously polls the computer's battery.

	Args:
		config (dictionary): A dictionary of the configuration file's contents.
	"""

	warned = False

	logging.info("starting battery checker")
	while True:
		level, status = _get_battery_status()
		levels = config["upper" if status == "charging" else "lower"]

		if level in levels:
			if not warned:
				msg = "Battery %s, level: %d." % (status, level)
				_emit_warning(msg, config["sound"])
				warned = True
		elif warned:
			warned = False

		time.sleep(config["interval"])
	logging.info("ending battery checker")

def _get_battery_status():
	"""
	Returns:
		(tuple of (int, string)) The status of the battery: its level and
		"charging"/"discharging".
	"""

	batt_output = subprocess.check_output(["upower", "-d"])

	def _extract_prop(prop):
		container_half = re.split(prop + ": +", batt_output)[-1]
		return container_half.split("\n")[0]

	return int(_extract_prop("percentage").rstrip("%")), \
		_extract_prop("state")

def _emit_warning(msg, sound_path):
	"""
	Flash a graphical popup warning message to the user, and play a sound.

	Args:
		msg (string): The message to display in the popup.
		sound_path (string): The path of the `.wav` file to play.
	"""

	subprocess.call(["aplay", sound_path])
	# subprocess.call(["zenity", "--warning", "--text", msg])
	logging.info("emitted warning `%s`", msg)
	subprocess.call([
		"xmessage", "-default", "Acknowledge", "-button", "Acknowledge",
		"-center", msg
	])

def _load_config(config_path):
	"""
	Reads and parses the config file. Also resolves its `sound` path to an
	absolute path.

	Args:
		path (string): The path of the YAML config file to load.

	Returns:
		(dictionary) A dictionary representation of the configuration file
			(`../res/battery_warning/config.yml`).
	"""

	curr_dir = os.path.dirname(os.path.realpath(__file__))
	config_path = os.path.join(curr_dir, config_path)

	with open(config_path) as config_file:
		config = yaml.load(config_file.read())
	logging.info("config file loaded")

	config["sound"] = os.path.join(
		os.path.dirname(config_path), config["sound"])
	return config

if __name__ == "__main__":
	logging.basicConfig(level=logging.DEBUG)
	_battery_checker(_load_config("../res/battery_warning/config.yml"))
