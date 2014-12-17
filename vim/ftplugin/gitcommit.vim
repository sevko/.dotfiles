setlocal sw=8
setlocal tw=72
setlocal colorcolumn=73
setlocal spell spelllang=en_us

syn match _gitcommit_abbr_hash "\v<\x{7}>"
syn match _gitcommit_changed_file "\v^\S.*$" contains=gitcommitDiff
syn match _gitcommit_subject_line "\v%1l%<51c."
syn match _gitcommit_uncapitalized "\v(^\t-)@<=\l"
syn match _gitcommit_bullet "\v(^\t)@<=-"

syn region _gitcommit_inline_code start="`" end="`"
syn match Comment "^#.*"

hi _gitcommit_changed_file ctermfg=4
hi _gitcommit_subject_line ctermfg=3
hi _gitcommit_uncapitalized ctermfg=160
hi _gitcommit_bullet cterm=bold ctermfg=9
hi _gitcommit_inline_code ctermfg=2
hi _gitcommit_abbr_hash ctermfg=5
hi diffAdded ctermfg=2

func! s:InsertStagedPaths()
	" Insert the paths of all files staged in `git`, beginning on the second
	" line of the open buffer.

	exe "norm! 0ggo\<cr>" . system("git diff --name-only --cached")
endfunc

if !exists("g:gitcommit_ftplugin_sourced")
	let g:gitcommit_ftplugin_sourced = 1
	call s:InsertStagedPaths()
endif

so ~/.vimrc_after
