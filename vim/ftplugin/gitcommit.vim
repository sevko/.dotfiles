syn match _gitcommitTypeOfChange "\(Add:\)\|\(Mod:\)\|\(Ref:\)\|\(Fix:\)\|\(Rem:\)\|\(Rea:\)\|"
syn match _gitcommitChangedFile "^\t[^\t].*"

hi _gitcommitTypeOfChange ctermfg=2
hi _gitcommitChangedFile ctermfg=4

so ~/.vimrc-after
