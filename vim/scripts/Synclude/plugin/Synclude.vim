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

func! s:SyncludeIncludeMatch(arg_string)
	" Import a syntax match, and apply highlighting.
	"
	" Args:
	"   arg_string : the arg string, in the following format:
	"           match_name [cterm=%s] [ctermfg=%s] [ctermbg=%s]

	let args = split(a:arg_string)
	if has_key(g:synclude_matches, l:args[0])
		let full_match_name = printf(
				\"_%s_%s", substitute(&ft, '\V.', "_", "g"), l:args[0])

		let syntax_args = []
		if 1 < len(l:args)
			let highlight_args = []

			for arg in l:args[1:]
				call add(
						\(l:arg =~ '\v^cterm([fb]g)=')?(l:highlight_args):
						\(l:syntax_args), l:arg)
			endfor

			if 0 < len(l:highlight_args)
				exe printf("norm! :hi %s %s\<cr>", l:full_match_name,
						\join(l:highlight_args))
			endif
		endif

		exe printf(
				\"syn match %s %s %s", l:full_match_name,
				\g:synclude_matches[l:args[0]], join(l:syntax_args))

	else
		echom printf(
				\"Synclude: syntax group '%s' not found in '%s'.", l:args[0],
				\g:synclude_matches_file)
	endif
endfunc

func! s:SyncludeCommandCompletion(argLead, cmdLine, cursorPos)
	" Completion function for the `Synclude` command.
	"
	" Args:
	"   argLead, cmdLine, cursorPos : see `:h :command-completion-custom`.
	"
	" Return:
	"   (str) All syntax group names as loaded from `g:synclude_matches_file`,
	"   seperated by newlines.

	return join(keys(g:synclude_matches), "\n")
endfunc

" See `SyncludeIncludeMatch()`.
com! -complete=custom,<SID>SyncludeCommandCompletion -nargs=*
		\ Synclude call <SID>SyncludeIncludeMatch("<args>")

" Open the matches file for editing.
com! SyncludeEdit exe printf("norm! :vsp %s\<cr>", g:synclude_matches_file)

call s:SyncludePopulateMatches()
