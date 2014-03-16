"""
Prints all public function headers in the C file specified as a command-line
argument.

Use:
	python c_function_headers.py C_FILE_PATH

	C_FILE_PATH -- path to a C source file.
"""

import sys, re

FUNCTION_HEADER_REGEX = "(?<=\n)(?!static)[^\t\n]*\([^)]*\n?[^)]*\){(?=\n)"

def scan_file(filename):
	"""
	Read in a file with name filename, and print all public headers (replacing
	the ending '{' with a ';').
	"""
	with open(filename, "r") as source_file:
		file_buffer = source_file.read()

	for header in re.findall(FUNCTION_HEADER_REGEX, file_buffer):
		print header[:-1] + ";"

if __name__ == "__main__":
	scan_file(sys.argv[1])
