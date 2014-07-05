#! /usr/bin/python

"""
A script that prints the computer's current battery level.
"""

def battery_level():
	"""
	Return the current battery level.

	Returns:
		(int) The current battery level [0-100], as read from the relevant
		system device diagnostic files.
	"""
	max_energy = curr_energy = -1
	battery_dir = "/sys/class/power_supply/BAT0/"

	with open("%s/energy_full" % battery_dir) as obj:
		max_energy = int(obj.read().rstrip("\n"))

	with open("%s/energy_now" % battery_dir) as obj:
		curr_energy = int(obj.read().rstrip("\n"))

	return curr_energy * 100 / max_energy

if __name__ == "__main__":
	print battery_level()
