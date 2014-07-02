syn match _pythonDocstringSection "^\s*\u\w*:$" containedin=Comment
hi _pythonDocstringSection ctermfg=9

nnoremap <leader>d :call PythonDocUtil#GenerateDocstring()<cr>
