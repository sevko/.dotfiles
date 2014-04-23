import json, os, shutil, subprocess

def command(cmd):
	print cmd if subprocess.call(cmd, shell=True) == 0 else "`%s` failed."

def create_symlink(link_name, target=None):
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

	command("ln -s %s %s" % (
			os.path.join(os.path.expanduser("~/.dotfiles"), target), link_name))

def link_files():
	JSON_SETUP_FILE = "setup.json"

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

def setup():
	print "Setting up."
	command("git submodule init")
	command("git submodule update")
	link_files()
	print "Setup complete."

if __name__ == "__main__":
	 setup()
