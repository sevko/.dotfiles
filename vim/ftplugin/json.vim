set colorcolumn=120 tw=119

syn match _jsonDictionaryKey "\"[^\"]*\"\([^:]*:\)\@="

hi _jsonDictionaryKey ctermfg=3
hi javaScriptNumber ctermfg=1
