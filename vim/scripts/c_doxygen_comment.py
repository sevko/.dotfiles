"""
:synopsis: Script for generating a Doxygen comment for a C function.

Contains functions for generating a Doxygen comment template for a C function
declaration or prototype.

A typical comment might look like:
.. code-block:: c
	/*
	 *  @brief
	 *
	 *  @param base
	 *  @param exponent
	 *
	 *  @return
	 */
	double power(double base, double exponent){ #...
"""

import fileinput, re

DOXYGEN_TEMPLATE = ("/*\n"
					" * @brief \n"
					"%s%s"
					" */")

def _generate_doxygen_comment(function):
	"""
	Return the full Doxygen template for a function.

	:param function: The function prototype/declaration string, with the
		the trailing ';' or '{' removed and any newlines replaced with spaces.

	:type function: str

	:return: The  Doxygen template for **function**.
	:rtype: str
	"""

	print DOXYGEN_TEMPLATE % (_get_parameters(function), _get_return(function))

def _get_parameters(function):
	"""
	Return the Doxygen parameter fields for the function.

	:param function: The function prototype/declaration string, with the
		the trailing ';' or '{' removed and any newlines replaced with spaces.

	:type function: str

	:return: Template "@param" fields for the **function**'s arguments, if any.
	:rtype: str
	"""

	args = re.findall("(?<=\().*(?=\)$)", function)[0]
	if len(args) == 0:
		return ""
	else:
		parameters = []
		for arg in args.split(","):
			arg_name = arg.split(" ")[-1]
			if arg_name != "void":
				parameters.append(" * @param %s " % arg_name)

		return " *\n%s\n" % "\n".join(parameters)

def _get_return(function):
	"""
	Return the Doxygen return fields for the function.

	:param function: The function prototype/declaration string, with the
		the trailing ';' or '{' removed and any newlines replaced with spaces.

	:type function: str

	:return: Template "@return" fields for the **function**'s returned value, if
		any.
	:rtype string:
	"""

	words = function.split(" ")
	if (words[0] == "void" and words[1] != "*") or \
			(words[1] == "void" and words[2] != "*"):
		return ""
	else:
		return " *\n * @return \n"

if __name__ == "__main__":
	function = "".join([line for line in fileinput.input()]).replace("\t", "")
	_generate_doxygen_comment(function)
