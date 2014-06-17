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

func! SyncludeIncludeMatch(match_name)
	" Import a syntax match.
	"
	" Args:
	"   match_name : the name of a syntax group.

	if has_key(g:synclude_matches, a:match_name)
		exe printf(
			\"syn match _%s %s", a:match_name, g:synclude_matches[a:match_name])
	else
		echom printf(
			\"Synclude: syntax group '%s' not found in '%s'.", a:match_name,
			\g:synclude_matches_file)
	endif
endfunc

" See `SyncludeIncludeMatch()`.
com! -nargs=1 Synclude call SyncludeIncludeMatch("<args>")

" Open the matches file for editing.
com! SyncludeEdit exe printf("norm! :vsp %s\<cr>", g:synclude_matches_file)

call s:SyncludePopulateMatches()
