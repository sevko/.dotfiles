" Plugin for common syntax match imports.
"
" Contains functions and commands that allow for easy inclusion (importing) of
" syntax matches that are common across programming languages, like constants
" or bitwise operators, to prevent redefinition (DRY).

if !exists("g:synclude_matches_file")
	let g:synclude_matches_file = glob("~/.vim/Synclude/matches.syn")
else
	let g:synclude_matches_file = glob(g:synclude_matches_file)
endif

func! s:PopulateCommonSyntaxGroups()
	" Read in syntax matches defined in 'groups.syn', and populate
	" `g:synclude_matches`.

	let g:synclude_matches = {}

	for line in readfile(g:synclude_matches_file)
		if line[0] != "#"
			let split_line = split(l:line)
			let g:synclude_matches[l:split_line[0]] = join(split_line[1:], " ")
		endif
	endfor
endfunc

" Import a syntax match.
"
" Args:
"   1 : The name of the match.
com! -nargs=1 Synclude exe printf("syn match _%s %s", "<args>",
	\g:synclude_matches["<args>"])

" Open the matches file for editing.
com! SyncludeEdit exe printf("norm! :vsp %s\<cr>", g:synclude_matches_file)

call s:PopulateCommonSyntaxGroups()
