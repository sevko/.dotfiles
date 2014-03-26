setlocal spell spelllang=en_us
setlocal textwidth=80

syn match _gitcommitTypeOfChange "\(Add:\)\|\(Mod:\)\|\(Ref:\)\|\(Fix:\)\|\(Rem:\)\|\(Rea:\)\|"
syn match _gitcommitChangedFile "^\t[^\t].*"
syn match _gitcommitSubjectLine "\%1l\%<51c."

syn match Comment "^#.*"

hi _gitcommitTypeOfChange ctermfg=2
hi _gitcommitChangedFile ctermfg=4
hi _gitcommitSubjectLine ctermfg=3

so ~/.vimrc_after
