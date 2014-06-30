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

so ~/.vimrc_after
