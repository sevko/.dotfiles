#! /usr/bin/python
# -*- coding: utf-8 -*-

"""
A script that prints information about the current weather, in a format ready
for tmux consumption.
"""

import os
import requests
import time

CHECK_INTERVAL = 10 * 60
CACHE_FILE = os.path.expanduser("~/.tmux_cache/weather.csv")

def get_weather():
	"""
	Return information about the current weather.

	Data queried from the `forecast_io` API is cached for a period of
	`CHECK_INTERVAL` seconds, so as to prevent frequent polling.

	Returns:
		(str) A formatted, tmux statusline snippet containing the current
		temperature and wind-speed.
	"""

	curr_time = int(time.time())
	diff_cache_mod_time = curr_time - int(os.path.getmtime(CACHE_FILE))
	if curr_time % CHECK_INTERVAL == 0 or \
		diff_cache_mod_time > (CHECK_INTERVAL * 1.1):
		api_url = "https://api.forecast.io/forecast/%s/%f,%f" % (
			file_contents("~/.sensitive/forecast_io_key.csv"), 40.7903,
			-73.9597
		)
		weather_json = requests.get(api_url).json()
		weather_segment = "❄ %s°#[fg=colour14]/#[fg=colour255]%smph" % (
			int(weather_json["currently"]["temperature"]),
			int(weather_json["currently"]["windSpeed"])
		)
		with open(CACHE_FILE, "w") as cache_file:
			cache_file.write(weather_segment)
		return weather_segment

	else:
		return file_contents(CACHE_FILE)

def file_contents(filename):
	"""
	Return the contents of a file.

	Args:
		path : (str) A file path.

	Return:
		(str) The file's contents, with any trailing newlines removed.
	"""

	with open(os.path.expanduser(filename)) as obj:
		return obj.read().rstrip("\n")

if __name__ == "__main__":
	print get_weather()
