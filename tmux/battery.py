#! /usr/bin/env python
# -*- coding: utf-8 -*-

"""
A script that prints the computer's current battery level and status.
"""

import subprocess
import sys
import os

curr_dir = os.path.dirname(os.path.realpath(__file__))
sys.path.append(os.path.join(curr_dir, "..", "shell_scripts"))
import battery_warningd

def _battery_info():
	"""
	Returns:
		(string) The battery level, followed by a `%`, followed by
		a Unicode energy symbol if the computer is currently charging.
	"""

	level, status = battery_warningd._get_battery_status()
	status_str = "%d%%%s" % (level, " ⚡" if status == "charging" else "")
	return status_str

if __name__ == "__main__":
	print _battery_info()
