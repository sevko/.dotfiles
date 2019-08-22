" Vim syntax file
" Language: Valgrind suppression file
" Maintainer: David Necas (Yeti) <yeti@physics.muni.cz>
" Last Change: 2011-02-06

if version >= 600
  " Quit when a syntax file was already loaded
  if exists("b:current_syntax")
    finish
  endif
endif

syn case match
syn sync minlines=12
syn match suppComment "^\s*#.*$" contains=suppTODO
syn keyword suppTODO TODO XXX FIXME contained
syn match suppRuleStart "^\s*\zs{" nextgroup=suppRuleName skipnl skipwhite
syn match suppRuleName "^\s*\zs[^}[:space:]].*$" contained contains=suppInsertName nextgroup=suppTool skipnl skipwhite
syn match suppInsertName "<insert_a_suppression_name_here>" contained
syn match suppTool "exp-ptrcheck\|drd" contained nextgroup=suppToolColon
syn keyword suppTool Memcheck Helgrind drd exp-ptrcheck exp-bbv contained nextgroup=suppToolColon
syn match suppToolColon ":" contained nextgroup=suppType
syn keyword suppType Value0 Value1 Value2 Value4 Value8 Value16 contained
syn keyword suppType Addr1 Addr2 Addr4 Addr8 Addr16 contained
syn keyword suppType Cond Jump Param Free Overlap Leak Race drd contained
syn keyword suppType SorG Arith Heap contained
syn match suppEllipsis "\.\.\."
syn match suppContextType "^\s*\zs\(fun\|obj\)" nextgroup=suppContextColon
syn match suppContextColon ":" contained nextgroup=suppContext
syn match suppContext "\S+" contained
syn match suppRuleEnd "^\s*\zs}"

hi def link suppComment         Comment
hi def link suppTODO            Todo
hi def link suppRuleStart       Special
hi def link suppRuleEnd         Special
hi def link suppEllipsis        Special
hi def link suppRuleName        Title
hi def link suppInsertName      Todo
hi def link suppTool            Keyword
hi def link suppUknownTool      Identifier
hi def link suppContextType     PreProc
hi def link suppType            Type

let b:current_syntax = "supp"
