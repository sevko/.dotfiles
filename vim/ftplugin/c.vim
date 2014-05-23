syn match _arithmetic_operator "+\|-\|\*\|%\|<\|>\|="
syn match _arithmetic_operator "\(/\|*\)\@<!/\(/\|*\)\@!"
syn match _logic_operator "&&\|||\|!"
syn match _bitwise_operator "\(&\)\@<!&\(&\)\@!"
syn match _bitwise_operator "\(|\)\@<!|\(|\)\@!"
syn match _bitwise_operator "<<\|>>\|\^"
syn match _surrounding_element "(\|)\|\[\|\]\|{\|}"
syn match _delimiters "\.\|,\|:"
syn match _end_of_line ";"
syn match _cConstant
	\ "\([a-zA-Z0-9]\)\@<!\u\([A-Z0-9_]*[A-Z0-9]\)\=\([a-z0-9A-Z_]\)\@!"
syn match _cGlobal "\([a-zA-Z0-9]\)\@<!g_[a-zA-Z0-9]\+\([a-zA-Z0-9]\)\@!"
syn match _cStruct "\([a-zA-Z0-9]\)[a-zA-Z0-9]\+_t\([a-zA-Z0-9]\)\@!"
syn match _cFunction "\(^[^# \t][^ \t].\+ \)\@<=[^ \t]\+\((\)\@="

hi _arithmetic_operator ctermfg=3
hi _logic_operator ctermfg=2
hi _bitwise_operator ctermfg=1
hi _surrounding_element ctermfg=2
hi _delimiters ctermfg=166
hi _end_of_line ctermfg=244
hi _cConstant cterm=bold ctermfg=70
hi _cGlobal ctermfg=1
hi _cStruct ctermfg=6
hi _cFunction ctermfg=4
hi _cDoxygenDirective cterm=bold ctermfg=10
hi _cDoxygenReference cterm=bold ctermfg=10

com! OpenHeaderVSplit exe "normal! :vsp " . expand("%:p:r") . ".h\<cr>"
com! OpenHeaderSplit exe "normal! :sp " . expand("%:p:r") . ".h\<cr>"
com! OpenSourceVSplit exe "normal! :vsp " . expand("%:p:r") . ".c\<cr>"
com! OpenSourceSplit exe "normal! :sp " . expand("%:p:r") . ".c\<cr>"

nnorem <buffer> <leader>; $a;<esc>
nnorem <buffer> <leader>oh :OpenHeaderVSplit<cr>
nnorem <buffer> <leader>ohs :OpenHeaderSplit<cr>
nnorem <buffer> <leader>oc :OpenSourceVSplit<cr>
nnorem <buffer> <leader>ocs :OpenSourceSplit<cr>
nnorem <buffer> <leader>gc :call GetHeaders()<cr>
" nnorem <buffer> <leader>d :call DoxygenComment()<cr>
"
nnorem { :call InsertBraces()<cr>
nnorem } :call DeleteBraces()<cr>

" print my preferred order of declaration statement
func! PrintTemplate()
	echom "
		\\n#include lib
		\\n#include system
		\\n#include local
		\\n
		\\n#define function-macro
		\\n#define object-macro
		\\n
		\\nextern variables
		\\n
		\\nstruct
		\\ntypedef
		\\nstatic variables
		\\nstatic function"
endfunc

func! GetHeaders()
	let script = "python ~/.dotfiles/vim/scripts/c_function_headers.py"
	silent! exec "read! " . script . " " . expand("%:p:r") . ".c"
endfunc

func! DeleteBraces()
	let l:curX = col(".")
	let l:curY = line(".")

	let l:innerNumTabs = len(matchstr(getline("."), '^\t*'))
	exe "norm! ?\\(^\t\\{1," . l:innerNumTabs . "\\}\\S.*)\\)\\@<={$\<cr>x"

	let l:outerNumTabs = len(matchstr(getline("."), '^\t*'))
	exe "norm! /\\(^\t\\{" . l:outerNumTabs . "\\}\\)\\@<=}\<cr>dd"

	call cursor(l:curY, l:curX)
endfunc

func! InsertBraces()
	let l:curX = col(".")
	let l:curY = line(".")

	" Insert an opening brace
	let l:innerNumTabs = len(matchstr(getline("."), '^\t*'))
	exe "norm! ?\\(^\t\\{1," . l:innerNumTabs . "\\}\\S.*\\)\\@<=)$\<cr>a{"

	" Insert a closing brace
	let l:outerNumTabs = len(matchstr(getline("."), '^\t*'))
	exe "norm! /^\t\\{1," . l:outerNumTabs . "\\}\\(\\S.*\\|$\\)\<cr>"
	exe "norm! ?^\t\\{" . (l:outerNumTabs + 1) . "\\}\<cr>"
	exe "norm! o}"

	call cursor(l:curY, l:curX)
endfunc

source ~/.dotfiles/vimrc_after
source ~/.dotfiles/vim/scripts/doxygen_utility.vim
