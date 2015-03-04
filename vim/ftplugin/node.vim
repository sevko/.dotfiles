let &l:include = 'require(\s\+\("\|''\)\zs.*\ze\1'
setl includeexpr=ResolveIncludePath(v:fname)

syn keyword Identifier module process  __dirname __filename
syn keyword Include require

func! ResolveIncludePath(path)
	" Converts a path found by `l:include` to an include-able file. Works for
	" local paths (eg `./lib/file.js`) and modules in `node_modules/`, for
	" which it consults `package.json` for a `main` module or default to
	" `index.js`. Should no path be found (for instance, for core libs), return
	" nothing.

	if a:path[0] == "."
		" Relative path.

		if a:path[-3:] == ".js"
			return a:path
		else
			return a:path . ".js"
		endif
	else

		" Search `node_modules/`.

python << endpython
import json
import os.path

module_path = "node_modules/{0}/".format(vim.eval("a:path"))
if os.path.isdir(module_path):
	package_json_path = module_path + "package.json"

	# Consult module's `package.json`'s `main` key.
	if os.path.isfile(package_json_path):
		with open(package_json_path) as package_json:
			package = json.loads(package_json.read())

			if "main" in package:
				main_path = package["main"]
				if main_path[-3:] != ".js":
					main_path += ".js"
			else:
				main_path = "index.js"
	else:
		main_path = "index.js"

	vim.command("let module_path = '{0}'".format(module_path + main_path))
endpython

		if exists("l:module_path")
			return l:module_path
		endif
	endif
endfunc

so ~/.vimrc_after
