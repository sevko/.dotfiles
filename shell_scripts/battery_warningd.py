import os
import re
import subprocess
import time
import yaml

def _battery_checker(config):
	warned = False

	while True:
		level, status = _get_battery_status()
		levels = config["upper" if status == "charging" else "lower"]

		print level, status

		if level in levels:
			if not warned:
				_emit_warning("Battery %s, level: %d." % (status, level))
				warned = True
		elif warned:
			warned = False

		time.sleep(config["interval"])

def _get_battery_status():
	batt_output = subprocess.check_output(["upower", "-d"])

	def _extract_prop(prop):
		container_half = re.split(prop + ": +", batt_output)[-1]
		return container_half.split("\n")[0]

	return int(_extract_prop("percentage").rstrip("%")), \
		_extract_prop("state")

def _emit_warning(msg):
	warning_wav_path = "../res/battery_warning/warning.wav"

	subprocess.call(
		["aplay", warning_wav_path], stdout=os.devnull, stderr=os.devnull
	)
	subprocess.call(
		[
			"xmessage", "-default", "Acknowledge", "-button", "Acknowledge",
			"-center", msg
		], stdout=os.devnull, stderr=os.devnull
	)

def _load_config():
	with open("../res/battery_warning/config.yml") as config_file:
		return yaml.load(config_file.read())

if __name__ == "__main__":
	_battery_checker(_load_config())
