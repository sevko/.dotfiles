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

func! s:SyncludePopulateMatches()
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

func! SyncludeIncludeMatch(arg_string)
	" Import a syntax match, and apply highlighting.
	"
	" Args:
	"   arg_string : the arg string, in the following format:
	"           match_name [cterm=%s] [ctermfg=%s] [ctermbg=%s]

	let args = split(a:arg_string)
	if has_key(g:synclude_matches, l:args[0])
		let full_match_name = printf("_%s_%s", &ft, args[0])
		exe printf(
				\"syn match %s %s", l:full_match_name,
				\g:synclude_matches[l:args[0]])

		if 1 < len(l:args)
			exe printf("norm! :hi %s %s\<cr>", l:full_match_name,
					\join(l:args[1:]))
		endif
	else
		echom printf(
				\"Synclude: syntax group '%s' not found in '%s'.", l:args[0],
				\g:synclude_matches_file)
	endif
endfunc

" See `SyncludeIncludeMatch()`.
com! -nargs=* Synclude call SyncludeIncludeMatch("<args>")

" Open the matches file for editing.
com! SyncludeEdit exe printf("norm! :vsp %s\<cr>", g:synclude_matches_file)

call s:SyncludePopulateMatches()
