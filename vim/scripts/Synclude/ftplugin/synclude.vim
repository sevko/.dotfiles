syn match Comment "^#.*$"
syn match syncludeGroupName "^\w\+"
syn match syncludeGroupRegex "\v(^\w+)@<=.*"

hi syncludeGroupName ctermfg=4
hi syncludeGroupRegex ctermfg=2
