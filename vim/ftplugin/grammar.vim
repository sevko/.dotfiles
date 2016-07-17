syn match  _grammar_option "|"
syn match _grammar_assignment "="
syn match _grammar_operators "[\[\]()\*+]"
syn region _grammar_literal start="'" end="'"

hi link _grammar_assignment Operator
hi link _grammar_option Operator
hi link _grammar_literal String
hi _grammar_operators ctermfg=9
