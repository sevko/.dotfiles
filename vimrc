" default
runtime! debian.vim

if has("syntax")
	syntax enable
endif

if filereadable("/etc/vim/vimrc.local")
	source /etc/vim/vimrc.local
endif

if has("autocmd")
	au bufreadpost * if line("'\"") > 1 && line("'\"") <= line("$")
		\| exe "normal! g'\"" | endif
endif

if &term =~ '^screen'
	execute "set <s-up>=\e[1;2A"
	execute "set <s-down>=\e[1;2B"
	execute "set <s-right>=\e[1;2C"
	execute "set <s-left>=\e[1;2D"
endif

call pathogen#infect("bundle/{}", "~/.dotfiles/vim/scripts/{}")
call pathogen#helptags()

filetype plugin indent on

" settings
set fileformats=unix
set showcmd
set autowrite
set ttyfast lazyredraw
set nu rnu
set nowrap
set splitbelow splitright
set incsearch

set runtimepath+=~/.dotfiles/vim/
set timeoutlen=280
set colorcolumn=80
set textwidth=79
set scrolloff=25
set noshowmatch
set wildmenu wildmode=longest,list,full
set backspace=indent,eol,start
set nf+=alpha
set laststatus=2
set t_Co=256
set pumheight=10
set complete+=k

set list lcs=tab:\·\ 

" colorscheme
set background=dark
silent! colorscheme solarized

" backup to ~/.tmp; get rid of .swp files
set backup
set backupdir=~/.vim-tmp,~/.tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,/var/tmp,/tmp
set writebackup

" indentation
set autoindent
set noexpandtab tabstop=4 shiftwidth=4

" code folding settings
set foldignore=
set foldmethod=indent
set foldnestmax=10
set nofoldenable foldlevel=1

" italic comments
highlight Comment cterm=underline
set t_ZH=[3m
set t_ZR=[23m

" UltiSnips
let g:UltiSnipsExpandTrigger = "<c-j>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
let g:UltiSnipsSnippetDirectories = ["ultisnips"]

" NERDCommenter
let NERDSpaceDelims = 1
let g:NERDCustomDelimiters = {
	\ "c": { "left": "//", "right": "",
		\ "leftAlt": "/*","rightAlt": "*/" },
	\ "pgsql": {"left": "--"},
	\ "hack_asm": {"left": "//"},
	\ "hack_vm": {"left": "//"}
\}

" NERDTree
" key-maps
let NERDTreeMapOpenSplit="s"
let NERDTreeMapOpenVSplit="v"

let NERDTreeMapActivateNode="h"
let NERDTreeMapToggleHidden="<c-h>"

let NERDTreeMapJumpFirstChild="<leader>k"
let NERDTreeMapJumpLastChild="<leader>j"

let NERDTreeWinSize=30
let NERDTreeWinSize=28
let NERDTreeIgnore = ["__pycache__", '\.pyc$']

" emmet
imap <c-e> <c-y>,
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall

" smart pasting
let &t_SI .= "\<esc>[?2004h"
let &t_EI .= "\<esc>[?2004l"

" tmux/vim pane navigation
let previous_title = substitute
	\(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
let &t_ti = "\<esc>]2;vim\<esc>\\" . &t_ti
let &t_te = "\<esc>]2;". previous_title . "\<esc>\\" . &t_te

" Synclude
let g:synclude_matches_file = "~/.dotfiles/vim/matches.syn"

" TapSurround
let g:surround_close_char = {
	\"<" : ">",
	\"{" : "}",
	\"(" : ")",
	\'"' : '"',
	\"'" : "'",
	\"[" : "]",
	\"*" : "*",
	\"$" : "$",
	\"`" : "`"
\}

" highlighting/syntax

hi cursorlinenr ctermfg=red ctermbg=0
hi folded cterm=none,bold ctermbg=2 ctermfg=black
hi wildmenu cterm=none ctermfg=232 ctermbg=2
hi specialkey cterm=none ctermfg=darkgrey ctermbg=none
hi nontext ctermfg=red
hi vertsplit ctermfg=black ctermbg=2
hi statuslinenc cterm=none ctermfg=black ctermbg=2
hi NonText ctermbg=15
hi Search ctermbg=1 ctermfg=8
hi SpellBad cterm=bold ctermfg=196

hi statusline cterm=none ctermbg=235
hi statuslinenc ctermfg=none ctermbg=236
hi MatchParen cterm=bold ctermfg=45 ctermbg=none
hi _extraWhitespace ctermbg=88

" autocomplete menu
hi pmenu cterm=none ctermbg=2 ctermfg=233
hi pmenusel ctermbg=233 ctermfg=red
hi pmenusbar cterm=none ctermbg=black
hi pmenuthumb cterm=none ctermbg=red

" tab-bar
hi TabLineFill cterm=none ctermbg=15
hi TabLineSel cterm=none ctermfg=231 ctermbg=32
hi TabLine cterm=none ctermfg=7 ctermbg=15

" statusline
hi User1 ctermfg=231 ctermbg=31
hi User2 ctermfg=160 ctermbg=31
hi User3 ctermfg=22 ctermbg=118

hi User4 ctermfg=231 ctermbg=1
hi User5 cterm=none ctermbg=235
hi User6 ctermfg=231 ctermbg=31
hi User7 cterm=bold ctermfg=234 ctermbg=253

" autocommands

augroup miscellaneous
	au!
	au WinEnter,BufRead,BufNewFile * silent! call StatusLine()
	au WinEnter * call NERDTreeQuit()
	au WinLeave * silent! call StatusLineNC()

	au InsertEnter * hi _extraWhitespace ctermbg=8
	au InsertEnter,WinLeave * set nornu
	au InsertEnter * set timeoutlen=140
	au InsertLeave * set timeoutlen=280
	au InsertLeave * hi _extraWhitespace ctermbg=88
	au InsertLeave,WinEnter * silent! exe &nu?"set rnu":""

	au FileType * exe "setlocal dict+=~/.vim/dict/" . &filetype . ".txt"
	au FileType modula2 set filetype=markdown
	au FileType cpp set filetype=c.cpp
	au FileType sql set filetype=pgsql.sql
	au FileType node set filetype=node.javascript
	au FileType arduino set filetype=processing

	au BufRead,BufNewFile * match _extraWhitespace /\s\+$/
	au bufnewfile * silent! call s:LoadTemplate()
	au BufRead {.,}pylintrc set ft=dosini
	au BufRead,BufNewFile *.json set filetype=javascript.json
	au BufReadPre,BufNewFile *.md let g:markdown_fenced_languages = [
		\"c", "python", "javascript", "sh"
	\]
	au BufRead,BufNewFile *.tmp exe "set ft=template." .
			\split(expand("%:t:r"), "_")[0]
	au BufRead *.supp set filetype=supp
	au BufRead,BufNewFile *.md set ft=markdown
	au BufRead *.val set filetype=valgrind
	au BufRead gitconfig set filetype=gitconfig
	au BufRead psqlrc set filetype=pgsql
	au BufRead .psqlrc set filetype=pgsql
	au BufReadPost ~/.vimrc exe "normal! zM"

	au BufWrite,BufRead,BufEnter * :let &titlestring=expand('%:t')
augroup END

" commands

com! ToggleUniversalFold :set foldmethod=indent <bar> exe "norm! " .
		\(&foldlevel != 0?"zM":"zR")
com! -nargs=1 Ftpackage so ~/.dotfiles/vim/ftpackage/<args>.vim
com! Haste :echo system("command haste " . shellescape(expand("%:p")))
com! Dpaste :call Dpaste()

" key mappings

let mapleader = " "

" global

map c <plug>NERDCommenterToggle
map <leader>c :echo "NOPE"
map <leader>cz <plug>NerdComComment

" normal

norem <f1> :NERDTreeToggle<cr>
nnorem <leader>ev :tabf $MYVIMRC<cr>
nnorem <leader>ef :call OpenFtpluginFile()<cr>
nnorem <leader>eu :call OpenUltiSnipsFile()<cr>
nnorem <leader>et :call OpenTemplateFile()<cr>

no <leader>ss :call SynStack()<cr>
nnorem <leader>w <esc>:w<cr>
nnorem <leader>q <esc>:q<cr>
nnorem <leader>wq <esc>:wq<cr>
nnorem <leader>fq <esc>:q!<cr>
nnorem <leader>wa <esc>:wa<cr>

" faster navigation
nnorem H b
nnorem L w
nnorem J 4j
nnorem K 4k
nnorem <leader>l $
nnorem <leader>h ^
nnorem <leader>j G
nnorem <leader>k gg

nnorem <leader>n :set rnu!<cr>
nnorem + <c-a>
nnorem _ <c-x>
nnorem = =<cr>
nnorem <c-f> zO
nnorem f za
nnorem <silent> F :ToggleUniversalFold<cr>
nnorem <leader>t :tabnext<cr>
nnorem <leader>st :tabprev<cr>

nnorem <leader>r :wincmd r<cr>
nnorem sv :source ~/.vimrc<cr>
nnorem ss :silent! sp 
nnorem vv :silent! vsp 
nnorem ;vsp :echo "Nope."
nnorem ;sp :echo "Nope."

nnorem b <c-v>
nnorem <leader>rt :call HardRetab("soft")<cr>
nnorem tt :silent! tabe 

nnorem <tab> >>
nnorem <s-tab> <<

nnorem <up> <esc>:call ResizeUp()<cr>
nnorem <down> <esc>:call ResizeDown()<cr>
nnorem <left> <esc>:call ResizeLeft()<cr>
nnorem <right> <esc>:call ResizeRight()<cr>

nmap <s-up> <up><up><up>
nmap <s-down> <down><down><down>
nmap <s-left> <left><left><left>
nmap <s-right> <right><right><right>

nnorem ; :
nnorem : <nop>
nnorem \ @
nnorem @ <nop>

" tmux/vim pane navigation
if exists('$TMUX')
	nnorem <silent> <c-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
	nnorem <silent> <c-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
	nnorem <silent> <c-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
	nnorem <silent> <c-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
else
	map <c-h> <c-w>h
	map <c-j> <c-w>j
	map <c-k> <c-w>k
	map <c-l> <c-w>l
endif

" operator-pending

" faster navigation
onorem H b
onorem L w
onorem J 4j
onorem K 4k
onorem <leader>l $
onorem <leader>h ^
onorem <leader>j G
onorem <leader>k gg

" insert

inorem <special><expr> <esc>[200~ SmartPaste()
im <F2> <plug>NERDCommenterInsert

" Scroll up/down auto-complete menu with j/k
inorem <expr> J ((pumvisible())?("\<c-n>\<c-n>\<c-n>"):("J"))
inorem <expr> K ((pumvisible())?("\<c-p>\<c-p>\<c-p>"):("K"))

inorem <c-p> <c-x><c-f>
inorem <c-n> <esc>:call SkipPastSymbol()<cr>a

inorem <tab> <c-r>=Tab_Or_Complete()<cr>
inorem <s-tab> <c-p>
inorem <bs> <c-r>=SmartBackspace(col("."), virtcol("."))<cr>

inorem <up> <esc>:call ResizeUp()<cr>i
inorem <down> <esc>:call ResizeDown()<cr>i
inorem <left> <esc>:call ResizeLeft()<cr>i
inorem <right> <esc>:call ResizeRight()<cr>i

inorem " ""<left>
inorem "" "
inorem ' ''<left>
inorem '' '
inorem ` ``<left>
inorem `` `

inorem <silent> <c-h> <esc>:TmuxNavigateLeft<cr>
inorem <silent> <c-j> <esc>:TmuxNavigateDown<cr>
inorem <silent> <c-k> <esc>:TmuxNavigateUp<cr>
inorem <silent> <c-l> <esc>:TmuxNavigateRight<cr>
inorem <silent> <c-\> <esc>:TmuxNavigatePrevious<cr>

inorem ( ()<left>
inorem (( ()
inorem [ []<left>
inorem [[ []
inorem { {<cr>}<esc>O
inorem {{ {}<left>

inorem <c-x> x<esc>:call EscapeAbbreviation()<cr>a

" visual

" Faster navigation
vnorem <leader>l $
vnorem <leader>h ^
vnorem <leader>j G
vnorem <leader>k gg
vnorem H b
vnorem L w
vnorem J 4j
vnorem K 4k

vnorem <leader>c "+y
vnoremap <tab> :<bs><bs><bs><bs><bs>call VisualIndent()<cr>
vnoremap <s-tab> :<bs><bs><bs><bs><bs>call VisualDeindent()<cr>
vnorem // y/<c-r>"<cr>

" functions

func! NERDTreeQuit()
	" If any NERDTree buffers are open, close them.

	redir => buffersoutput
	silent buffers
	redir END
	let pattern = '^\s*\(\d\+\)\(.....\) "\(.*\)"\s\+line \(\d\+\)$'
	let windowfound = 0

	for bline in split(buffersoutput, "\n")
		let m = matchlist(bline, pattern)

		if (len(m) > 0)
			if (m[2] =~ '..a..')
				let windowfound = 1
			endif
		endif
	endfor

	if (!windowfound)
		quitall
	endif
endfunc

func! OpenFtpluginFile()
	for filetype in split(&ft, '\V.')
		exe printf(
				\"norm! :tabe $HOME/.dotfiles/vim/ftplugin/%s.vim\<cr>",
				\l:filetype)
	endfor
endfunc

func! OpenTemplateFile()
	for filetype in split(&ft, '\V.')
		let filepath = glob(
			\printf("$HOME/.dotfiles/vim/templates/%s_%s.tmp", &ft,
			\expand("%:e")))
		if empty(l:filepath)
			let filepath = glob(
				\printf("$HOME/.dotfiles/vim/templates/%s.tmp", &ft))
		endif
		exe printf("norm! :tabe %s\<cr>", l:filepath)
	endfor
endfunc

func! OpenUltiSnipsFile()
	for filetype in split(&ft, '\V.')
		exe printf(
				\"norm! :tabe $HOME/.dotfiles/vim/ultisnips/" .
				\"%s.snippets\<cr>", l:filetype)
	endfor
endfunc

func! VisualIndent()
	" Indent a block of text in visual mode, then restore the visual
	" selection shifted right by the indentation width.

	let start_line = line("'<")
	let end_line = line("'>")

	for line in range(start_line, end_line)
		silent! exec "normal! " . line . "gg>>"
	endfor
	exec "normal! l" . start_line . "gg\<c-v>" . end_line . "gg"
endfunc

func! VisualDeindent()
	" Deindent a block of text in visual mode, then restore the visual
	" selection shifted left by the indentation width.

	let start_line = line("'<")
	let end_line = line("'>")

	if col("'<") > 1
		for line in range(start_line, end_line)
			silent! exec "normal! " . line . "gg<<"
		endfor
		exec "normal! h"
	endif

	exec "normal! " . start_line . "gg\<c-v>" . end_line . "gg"
endfunc

func! Tab_Or_Complete()
	" If the preceding letter is a keyword-character, trigger
	" autocompletion; otherwise, insert the output of `SmartTab()`.

	func! SmartTab(colPos)
		" Insert either a soft or hard tab, depending on the contents of the
		" line preceding the cursor position.
		"
		" Args:
		"   colPos : (int) Output of `col(".")`.
		"
		" Return:
		"   (str) If any preceding characters are only hard-tabs, insert a
		"   hard tab otherwise, insert a soft tab.

		let currLn = getline(".")
		if a:colPos == 1 || currLn[:a:colPos - 2] =~ "^[\t]*$"
			return "\<tab>"
		else
			return repeat(" ", &tabstop - (virtcol(".") - 1) % &tabstop)
		endif
	endfunc

	let colPos = col('.')
	if colPos > 1 && strpart(getline('.'), colPos - 2, 3) =~ '^\k'
		return "\<c-n>"
	else
		return SmartTab(colPos)
	endif
endfunc

func! SmartBackspace(colPos, virtColPos)
	" If the cursor position is preceded by multiple spaces, delete all
	" spaces until the last tab-stop column.
	"
	" Args:
	"   colPos : (int) Output of `col(".")`.
	"   virtColPos : (int) Output of `virtcol(".")`.

	let distFromStart = (a:virtColPos - 1) % &tabstop
	if distFromStart == 0
		let distFromStart = &tabstop
	endif

	let virtColPos = a:virtColPos - distFromStart
	let startRealIndent = a:colPos - distFromStart

	if startRealIndent >= 1 &&
		\ getline('.')[startRealIndent - 1: a:colPos - 2] =~ "^[ ]*$"
		return repeat("\<bs>", (a:colPos - startRealIndent))
	else
		return "\<bs>"
	endif
endfunc

func! SmartPaste()
	" Toggles `paste` when pasting from the system clipboard.

	set pastetoggle=<esc>[201~
	set paste
	return ""
endfunc

func! TmuxOrSplitSwitch(wincmd, tmuxdir)
	" Facilitates seamless navigation across tmux/vim splits with a single
	" set of keymaps.

	let previous_winnr = winnr()
	silent! execute "wincmd " . a:wincmd
	if previous_winnr == winnr()
		call system("tmux select-pane -" . a:tmuxdir)
	redraw!
	endif
endfunc

func! HardRetab(tab_type)
	" Retab whitespace at the beginning of all lines.
	"
	" Args:
	"   tab_type : (str) If "soft", convert all soft-tabs to hard-tabs.
	"       If "hard", convert all hard-tabs into soft-tabs.

	let start_cur_pos = getcurpos()
	let soft_tab = repeat(" ", &tabstop)

	if a:tab_type == "soft"
		let soft_tab_regex = '\(^\(' . soft_tab . '\)*\)\@<=' .
			\ soft_tab
		silent! exec "normal! :%s/" . soft_tab_regex . "/\t/g\<cr>"
	elseif a:tab_type == "hard"
		let hard_tab_regex = "\\(^[\t]*\\)\\@<=\t"
		silent! exec "normal! :%s/" . hard_tab_regex . "/" . soft_tab .
			\ "/g\<cr>"
	endif
	call setpos(".", start_cur_pos)
endfunc

func! EscapeAbbreviation()
	" Enter a space and suppress any abbreviation expansion.

	exe printf("norm! x%s ", (col(".") == len(getline("."))?"a":"i"))
endfunc

func! GetScriptNumber(script_name)
	" Return the <SNR> of a script.
	"
	" Args:
	"   script_name : (str) The name of a sourced script.
	"
	" Return:
	"   (int) The <SNR> of the script; if the script isn't found, -1.

	redir => scriptnames
	silent! scriptnames
	redir END

	for script in split(l:scriptnames, "\n")
		if l:script =~ a:script_name
			return str2nr(split(l:script, ":")[0])
		endif
	endfor

	return -1
endfunc

func! s:LoadTemplate()
	" Load a template for a new file.
	"
	" Read a template for a new file, if one exists, and perform flag
	" substitution. Accounts for dotted filetypes (prioritizing templates
	" by order of filetype).

	func! s:ReadFiletypeTemplate(filetype)
		" If a template for the current file exists, read it into the
		" buffer.
		"
		" Template filenames can take the following format, in order of
		" descending priority.
		"
		"   1. "%s_%s" % (filetype, file-extension)
		"   2. "%s" % (filetype)
		"
		" Args:
		"   filetype (str): The filetype to load a template for.
		"
		" Returns:
		"   int: 1 if a file was found; 0 otherwise.

		let templatesDir = "~/.dotfiles/vim/templates"
		let templatePath = glob(printf(
				\"%s/%s_%s.tmp", l:templatesDir, a:filetype,
				\expand("%:e")))

		if empty(l:templatePath)
			let templatePath = glob(printf(
					\"%s/%s.tmp", l:templatesDir, a:filetype))
			if empty(l:templatePath)
				return 0
			endif
		endif

		exe printf("read %s", l:templatePath)
		0d

		return 1
	endfunc

	func! s:SubstituteTemplateFlags()
		" Perform flag substitution after a template file has been loaded.

		let template_flags = {
			\"__FILEBASE__" : expand("%:r")
		\}

		for flag in keys(l:template_flags)
			exe printf(
				\"%%s/%s/%s/g", l:flag,
				\substitute(l:template_flags[l:flag], "/", '\\/', "g"))
		endfor

		exe "norm! /__START__\<cr>9x"
		startinsert!
	endfunc

	for filetype in split(&ft, '\V.')
		if s:ReadFiletypeTemplate(l:filetype)
			call s:SubstituteTemplateFlags()
			return
		endif
	endfor
endfunc

func! SynStack()
	" Print the names of the syntax groups for the word under the cursor.

	if exists("*synstack")
		echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
	endif
endfunc

func! StatusLine()
	" Statusline generator for the currently selected window split.

	func! GitBranchName()
		" Return the open file's Git work-tree's branch name.
		"
		" Return:
		"   (str) If the open file is inside a Git tree, return its current
		"   branch; otherwise, "".

		let gitCommand = "cd " . expand("%:p:h") . " &&
			\ git rev-parse --is-inside-work-tree > /dev/null 2>&1 &&
			\ (git symbolic-ref --short HEAD 2> /dev/null ||
			\ git rev-parse HEAD | cut -b-10)"
		let branchName = system(gitCommand)
		if len(branchName) > 0
			return " " . branchName[:len(branchName) - 2] . "  "
		else
			return ""
		endif
	endfunc

	setl statusline=%1*\ %t\  " filename
	setl statusline+=%4*%{&ff!='unix'?'-------NOTUNIX-------':''}
	setl stl+=%2*%{&readonly?'\ ':''} " readonly

	if !exists("b:gitBranchName")
		let b:gitBranchName = GitBranchName()
	endif

	setl stl+=%3*%{b:gitBranchName} " branch name

	" modified (note unicode space)
	setl stl+=%4*%{&modified?' +\ ':''}
	setl stl+=%5*%= " right justify
	setl stl+=%6*\ %{strlen(&ft)?&ft:'none'}\  " filetype
	setl stl+=%7*\ %p%%\  " percent of file
endfunc

func! StatusLineNC()
	" Statusline generator for idle window splits.

	setl statusline=%1*\ %t\  " filename
	setl stl+=%4*%{&modified?'\ +\ ':''} " modified
	setl stl+=%5*%= " right justify
endfunc

func! SetFiletypeToMarkdown()
	" Set the filetype to "markdown", and initilize
	" `g:markdown_fenced_languages` (`g:markdown_fenced_languages` must be
	" set before the "markdown" ftplugin files are loaded). A function is
	" the cleanest way to bundle them together.

	set filetype=markdown
	let g:markdown_fenced_languages = ["c", "python", "javascript"]
endfunc

func! SkipPastSymbol()
	" Move the cursor past the next `symbolRegex` without leaving insert-mode.

	let symbolRegex = '[)\]}]'
	let currLn = getline(".")
	if currLn[getcurpos()[2]:] =~ symbolRegex
		exe "norm! /" . symbolRegex . "\<cr>"
	endif
endfunc
