"""
:synopsis: Perform all necessary setup for a newly cloned `.dotfiles/`.

Links existing dotfiles to their counterparts in `.dotfiles/`, initializes
the repository's Git submodules, and performs other vital setup.
"""

import json, os, shutil, subprocess

class Shell:
	"""
	Class containing useful constants for text effects/colors in the terminal.
	"""

	MAX_LINE_LEN = 120

	BOLD = "\033[1m"
	COLOR = "\033[38;5;%dm"
	NORMAL = "\033[0;00m"

	SUCCESS = "%s%s%s%s" % (BOLD, COLOR % 34, u"\u2713", NORMAL)
	FAILURE = "%s%s%s%s" % (BOLD, COLOR % 160, u"\u2718", NORMAL)
	HEADER = "\n%s%s%s%s" % (BOLD, COLOR % 33, "%s", NORMAL)

def command(cmd):
	"""
	Execute a command in a subprocess, with status reporting.

	Execute  the command, and print it along with `Shell.SUCCESS` or
	`Shell.FAILURE` depending on the command's exit code.

	:param cmd: The command and any arguments passed to `subprocess.call()`.

	:type cmd: array of str
	"""

	with open(os.devnull, "w") as devnull:
		exit_status = Shell.SUCCESS if subprocess.call(cmd,
				stdout=devnull, stderr=devnull) == 0 else Shell.FAILURE
	trimmed_cmd = " ".join(cmd[:Shell.MAX_LINE_LEN - 1]).ljust(
			Shell.MAX_LINE_LEN - 1)
	print "%s%s" % (trimmed_cmd, exit_status)

def create_symlink(link_name, target=None):
	"""
	Create a symlink between a file/directory and its counterpart in
	*.dotfiles/*.

	Existing files/directories at the path of *link_name* are deleted.

	:param link_name: The path of the symbolic link to be created.
	:param target: The path of the target in *.dotfiles/* the link should point
		to; if None, the target is assumed to be in the root of *.dotfiles/*,
		with an identical filename (albeit with any leading periods removed).

	:type link_name: str, or None
	:type target: str, or None
	"""

	link_name = os.path.expanduser(link_name)

	if target is None:
		target = os.path.basename(link_name).strip(".")

	if os.path.islink(link_name):
		os.unlink(link_name)
	elif os.path.isdir(link_name):
		shutil.rmtree(link_name)
	elif os.path.isfile(link_name):
		os.remove(link_name)
	else:
		link_basename = os.path.dirname(link_name)
		if not os.path.isdir(link_basename):
			os.makedirs(link_basename)

	command(["ln", "-s", os.path.join(os.path.expanduser("~/.dotfiles"),
			target), link_name])

def link_files():
	"""
	Create symlinks to `.dotfiles/`.

	Create symlinks between existing files and directories, scattered across a
	given filesystem, with their counterparts in `.dotfiles/`. The paths of
	files to be linked are specified in `setup.json`.
	"""

	JSON_SETUP_FILE = "setup.json"

	print Shell.HEADER % "Creating dotfile symlinks."

	try:
		with open(JSON_SETUP_FILE) as setup_file:
			files = json.loads(setup_file.read())
	except IOError as exception:
		print "%s: Failed to open %s for reading" % (exception, JSON_SETUP_FILE)
		return

	for link_name in files["regular_files"]:
		create_symlink(link_name)

	for link_name in files["special_files"].keys():
		create_symlink(link_name, target=files["special_files"][link_name])

def update_git_submodules():
	"""
	Initialize and update `.dotfiles/` submodules.
	"""

	print Shell.HEADER % "Initializing and updating Git submodules."

	command(["git", "submodule", "init"])
	with open(".gitmodules") as gitmodules_file:
		lines = [line.strip("\n") for line in gitmodules_file]
	submodule_paths = [line.split("path = ")[1] for line in lines[1::3]]

	for path in submodule_paths:
		command(["git", "submodule", "update", path])

def setup():
	"""
	Call all `.dotfiles/` setup functions.
	"""

	print Shell.HEADER % "Setup: begin."
	link_files()
	update_git_submodules()
	print Shell.HEADER % "Setup: end."

if __name__ == "__main__":
	 setup()
