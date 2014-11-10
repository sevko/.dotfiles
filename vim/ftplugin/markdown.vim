setlocal spell spelllang=en_us
set iskeyword-=.
set ts=4 sw=4
so ~/.vimrc_after

hi htmlItalic cterm=underline
hi markdownCode ctermfg=2

unlet b:current_syntax
syn include @latex syntax/tex.vim
syn region _markdown_math_inline start="\V$" end="\V$" contains=@latex keepend
syn region _markdown_math_block start="\V$$" end="\V$$" contains=@latex keepend
