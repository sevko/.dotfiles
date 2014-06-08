syn match _arithmeticOperator "[+\-*%<>=]"
" syn match _arithmeticOperator "\(/\|*\)\@<!/\(/\|*\)\@!"

syn match _bitwiseOperator "\(&\)\@<!&\(&\)\@!"
syn match _bitwiseOperator "\(|\)\@<!|\(|\)\@!"
syn match _bitwiseOperator "<<\|>>\|\^"

syn match _surroundingElement "(\|)\|\[\|\]\|{\|}"

hi _arithmeticOperator ctermfg=3
hi _bitwiseOperator ctermfg=1
hi _surroundingElement ctermfg=2
