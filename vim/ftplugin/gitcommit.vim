set tw=80
setlocal spell spelllang=en_us

syn match _gitcommitTypeOfChange
	\ "^[^\t]*\(Add\|Mod\|Ref\|Fix\|Rem\|Rea\)\([^a-zA-Z0-9]\)\@="
syn match _gitcommitChangedFile "^\t[^\t]\+$"
syn match _gitcommitSubjectLine "\%1l\%<51c."
syn match _gitcommitUncapitalized "\(^\t\+-\)\@<=[a-z]"
syn match _gitcommitBullet "\(^\t\+\)\@<=-"

syn match Comment "^#.*"

hi _gitcommitTypeOfChange ctermfg=2
hi _gitcommitChangedFile ctermfg=4
hi _gitcommitSubjectLine ctermfg=3
hi _gitcommitUncapitalized ctermfg=160
hi _gitcommitBullet cterm=bold ctermfg=9

so ~/.vimrc_after
