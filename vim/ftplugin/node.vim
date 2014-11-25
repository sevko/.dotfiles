let &l:include = 'require(\s\+\("\|''\)\zs.*\ze\1'
setl includeexpr=ResolveIncludePath(v:fname)

func! ResolveIncludePath(path)
	echom "CALLED!"
	if a:path[0] == "."
		if a:path[-3:] == ".js"
			return a:path
		else
			return a:path . ".js"
		endif
	else

python << endpython
import json
import os.path

module_path = "node_modules/{0}/".format(vim.eval("a:path"))
if os.path.isdir(module_path):
	package_json_path = module_path + "package.json"
	if os.path.isfile(package_json_path):
		with open(package_json_path) as package_json:
			package = json.loads(package_json.read())
			main_path = package["main"]
			if main_path[-3:] != ".js":
				main_path += ".js"
	else:
		main_path = "index.js"
	vim.command("let module_path = '{0}'".format(module_path + main_path))
endpython

		if !exists("l:module_path")
			echom a:path
		else
			return l:module_path
		endif
	endif
endfunc

syn keyword Identifier module process  __dirname __filename
syn keyword Include require
