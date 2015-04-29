setl colorcolumn=120 tw=119

syn match _jsonDictionaryKey "\"[^\"]*\"\([^:]*:\)\@="

hi _jsonDictionaryKey ctermfg=3

func! Yaml2Json() range
	" Convert the YAML inside the lines in the current visual selection
	" (everything between the first and last lines is used, NOT just the
	" contents of the selection) to JSON. The indentation of the first line is
	" treated as the indentation of the entire block.

	let yaml_lines = getline(a:firstline, a:lastline)
	let indent_str = matchstr(yaml_lines[0], '^\s\+')
	let stripped_yaml_lines = map(yaml_lines, 'substitute(v:val, "^' . indent_str . '", "", "")')
	let stripped_yaml_lines = map(stripped_yaml_lines, 'substitute(v:val, "\t\\+", "\\=repeat(\"  \", strlen(submatch(0)))", "")')
	let tempFilePath = tempname()
	cal writefile(stripped_yaml_lines, tempFilePath)
	call system(expand("~") . "/.dotfiles/vim/scripts/yaml2json.py " . tempFilePath)
	exe "norm! " . (a:lastline - a:firstline + 1) . "dd"
	let json_lines = map(readfile(tempFilePath), printf('"%s" . v:val', indent_str))
	call append(a:firstline - 1, json_lines)
endfunc
