#! /usr/bin/python

"""
A script that prints the computer's current battery level and status.
"""

def battery_info():
	"""
	Returns information about the computer's battery.

	Returns:
		(str) The current battery level, and a Unicode "energy" symbol if it's
		charging.
	"""

	try:
		level = (int(file_contents("energy_now")) * 100 /
			int(file_contents("energy_full")))
		status = file_contents("status")
	except:
		return "N/A"
	charge_symbol = u" \u26a1".encode("utf-8")

	return "%d%%%s" % (level, charge_symbol if status == "Charging" else "")

def file_contents(filename):
	"""
	Return the contents of a battery status file.

	Args:
		path : (str) The path to a file inside `battery_dir`.

	Return:
		(str) The file's contents, with any trailing newlines removed.
	"""

	battery_dir = "/sys/class/power_supply/BAT0/"
	with open("%s/%s" % (battery_dir, filename)) as obj:
		return obj.read().rstrip("\n")

if __name__ == "__main__":
	print battery_info()
