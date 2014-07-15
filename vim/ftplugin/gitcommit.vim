setlocal tw=72
setlocal colorcolumn=73
setlocal spell spelllang=en_us

syn match _gitcommitChangedFile "\v^\S.*$" contains=gitcommitDiff,Comment
syn match _gitcommitSubjectLine "\v%1l%<51c."
syn match _gitcommitUncapitalized "\v(^\t-)@<=\l"
syn match _gitcommitBullet "\v(^\t)@<=-"

syn region _gitcommitInlineCode start="`" end="`"
syn match Comment "^#.*"

hi _gitcommitChangedFile ctermfg=4
hi _gitcommitSubjectLine ctermfg=3
hi _gitcommitUncapitalized ctermfg=160
hi _gitcommitBullet cterm=bold ctermfg=9
hi _gitcommitInlineCode ctermfg=2
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
