" default

	" This line should not be removed as it ensures that various options are
	" properly set to work with the Vim-related packages available in Debian.
	runtime! debian.vim

	call pathogen#incubate()
	call pathogen#helptags()

	if has("syntax")
		syntax enable
	endif

	if filereadable("/etc/vim/vimrc.local")
	  source /etc/vim/vimrc.local
	endif

	" jump to the last position when reopening a file
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

" settings

	filetype indent on
	filetype plugin on

	" colorscheme
	if isdirectory(glob("~/.vim/bundle/vim-colors-solarized"))
		set background=dark
		colorscheme solarized
	endif

	set showcmd
	set autowrite

	" file backup
		" backup to ~/.tmp; get rid of .swp files
		set backup
		set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
		set backupskip=/tmp/*,/private/tmp/*
		set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
		set writebackup

	set nu rnu
	set nowrap
	set linebreak

	set timeoutlen=280
	set colorcolumn=81
	set scrolloff=25 sidescrolloff=24
	set noshowmatch
	set wildmenu wildmode=longest,list,full
	set backspace=indent,eol,start

	" indentation
		set autoindent
		set noexpandtab tabstop=4 shiftwidth=4

	" code folding settings
		set foldmethod=indent
		set foldnestmax=10
		set nofoldenable foldlevel=1

	set splitbelow splitright

	set laststatus=2
	set incsearch
	set nocursorline
	set t_Co=256

	set list lcs=tab:\·\ 

	" italic comments
		highlight Comment cterm=italic
		set t_ZH=[3m
		set t_ZR=[23m

	" NERDTree
		" key-maps
		let NERDTreeMapOpenSplit="s"
		let NERDTreeMapOpenVSplit="v"

		let NERDTreeMapActivateNode="h"
		let NERDTreeMapToggleHidden="<c-h>"

		let NERDTreeMapJumpFirstChild="<leader>k"
		let NERDTreeMapJumpLastChild="<leader>j"

		let NERDTreeWinSize=26

	" NERDCommenter
		let NERDSpaceDelims = 1
		let g:NERDCustomDelimiters = {
			\ 'c': {  'left': '//', 'right': '', 'leftAlt': '/*','rightAlt': '*/' },
		\}

	" smart pasting
		let &t_SI .= "\<esc>[?2004h"
		let &t_EI .= "\<esc>[?2004l"

	" tmux/vim pane navigation
		let previous_title = substitute
			\(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
		let &t_ti = "\<esc>]2;vim\<Esc>\\" . &t_ti
		let &t_te = "\<esc>]2;". previous_title . "\<Esc>\\" . &t_te

	" toggle-surround
		let surround_close_char = {
			\"<" : ">",
			\"%" : "%",
			\"{" : "}",
			\"(" : ")",
			\'"' : '"',
			\"'" : "'",
			\"[" : "]"
		\}

" highlighting

	hi cursorlinenr ctermfg=red ctermbg=0
	hi folded ctermbg=2 ctermfg=black
	hi wildmenu cterm=none ctermfg=232 ctermbg=2
	hi specialkey cterm=none ctermfg=darkgrey ctermbg=none
	hi nontext ctermfg=red
	hi vertsplit ctermfg=black ctermbg=2
	hi statuslinenc cterm=none ctermfg=black ctermbg=2
	hi extraWhiteSpace cterm=none ctermbg=88 | match extraWhiteSpace /\s\+$/
	hi NonText ctermbg=15

	hi statusline cterm=none ctermbg=235
	hi statuslinenc ctermfg=none ctermbg=235

	" autocomplete menu
		hi pmenu cterm=none ctermbg=2 ctermfg=233
		hi pmenusel ctermbg=233 ctermfg=red
		hi pmenusbar cterm=none ctermbg=black
		hi pmenuthumb cterm=none ctermbg=red

	" tab-bar
		hi TabLineFill cterm=none ctermfg=23 ctermbg=7
		hi TabLineSel cterm=none ctermfg=231 ctermbg=32
		hi TabLine cterm=none ctermfg=0 ctermbg=7

	" statusline
		" highlighting for status line components
		hi User1 ctermfg=231 ctermbg=31
		hi User2 ctermfg=160 ctermbg=31
		hi User3 ctermfg=22  ctermbg=118

		hi User4 ctermfg=231 ctermbg=1
		hi User5 cterm=none ctermbg=235
		hi User6 ctermfg=231 ctermbg=31
		hi User7 cterm=bold ctermfg=234 ctermbg=253

	hi MatchParen cterm=bold ctermfg=45 ctermbg=none

" autocommands

	augroup miscellaneous
		au!
		au WinEnter * call NERDTreeQuit()
		au WinEnter,BufRead,BufNewFile * call StatusLine()
		au WinLeave * call StatusLineNC()

		au bufnewfile * call LoadTemplate()

		au BufRead  *.tmp set filetype=template
		au BufReadPost  ~/.vimrc exe "normal! zM"
		au BufWritePost ~/.vimrc source ~/.vimrc

		au InsertEnter * hi clear extraWhiteSpace
		au InsertLeave * hi extraWhiteSpace cterm=none ctermbg=88
		au InsertEnter,WinLeave * set nornu
		au InsertLeave,WinEnter * set rnu

		au Filetype gitcommit,markdown,text setlocal spell textwidth=80
	augroup END

" key mappings

	let mapleader = " "

	" global

		norem        <F1>             :NERDTreeToggle<cr>

		map            <leader>c        <plug>NERDCommenterToggle
		map            <leader>cz       <plug>NerdComComment

	" normal

		norem    <leader>ev       :vsplit $MYVIMRC<cr>
		nnorem   <leader>w        <esc>:w<cr>
		nnorem   <leader>q        <esc>:q<cr>
		nnorem   <leader>wq       <esc>:wq<cr>
		nnorem   <leader>fq       <esc>:q!<cr>
		nnorem   <leader>wa       <esc>:wa<cr>

		" Faster navigation
		nnorem    H               b
		nnorem    L               w
		nnorem    J               4j
		nnorem    K               4k
		nnorem    <leader>l       $
		nnorem    <leader>h       ^
		nnorem    <leader>j       G
		nnorem    <leader>k       gg

		nnorem    <leader>n       :call NumberToggle()<cr>
		nnorem    <tab>           .
		nnorem    =               =<cr>
		nnorem    f               za
		nnorem    F               :call ToggleUniversalFold()<cr>
		nnorem    <leader>t       :tabnext<cr>
		nnorem    <leader>st      :tabprev<cr>

		nnorem    <leader>r       :wincmd r<cr>
		nnorem    sv              :source ~/.vimrc<cr>
		nnorem    s               :set 

		nnorem    <c-a>           ggvG$
		nnorem    b               <c-v>
		nnorem    <leader>rt      :retab!<cr>
		nnorem    tt              :tabf

		" tmux/vim pane navigation
		if exists('$TMUX')
			nnorem <silent> <c-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
			nnorem <silent> <c-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
			nnorem <silent> <c-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
			nnorem <silent> <c-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
		else
			map <c-h> <C-w>h
			map <c-j> <C-w>j
			map <c-k> <C-w>k
			map <c-l> <C-w>l
		endif

	" operator-pending

		" Faster navigation
		onorem    H            b
		onorem    L            w
		onorem    J            4j
		onorem    K            4k
		onorem    <leader>l    $
		onorem    <leader>h    ^
		onorem    <leader>j    G
		onorem    <leader>k    gg

	" insert

		inorem    <special><expr>            <esc>[200~ SmartPaste()

		"Scroll up/down auto-complete menu with j/k
		inorem    <expr> j        ((pumvisible())?("\<c-n>"):("j"))
		inorem    <expr> k        ((pumvisible())?("\<c-p>"):("k"))
		inorem    <tab>           <c-r>=Tab_Or_Complete()<cr>
		inorem    <bs>            <c-r>=SmartBackspace(col("."), virtcol("."))<cr>
		inorem    jk              <esc>

		inorem    "               ""<left>
		inorem    '               ''<left>
		inorem    ""              "
		inorem    ''              '
		inorem    (               ()<left>
		inorem    ((              ()
		inorem    [               []<left>
		inorem    [[              []
		inorem    {{              {}<left>
		inorem    {               {<cr>}<esc>O

		inorem    <up>            <esc>:call ResizeUp()<cr>
		inorem    <down>          <esc>:call ResizeDown()<cr>
		inorem    <left>          <esc>:call ResizeLeft()<cr>
		inorem    <right>         <esc>:call ResizeRight()<cr>

		nm        <S-up>          <up><up>
		nm        <S-down>        <down><down>
		nm        <S-left>        <left><left>
		nm        <S-right>       <right><right>

		nm        \c              <plug>NERDCommenterInsert

	" visual

		vnorem jk                 <esc>

		" Faster navigation"
		vnorem    <leader>l       $
		vnorem    <leader>h       0
		vnorem    <leader>j       G
		vnorem    <leader>k       gg
		vnorem    H               b
		vnorem    L               w
		vnorem    J               4j
		vnorem    K               4k

		vnorem    <s-tab>         :call BlockSmartBackspace()<cr>gv
		vnorem    <tab>           :call BlockSmartTab()<cr>gv
		vnorem    <leader>c       "+y

" functions

	" toggles between relative and absolute line numbering
	function! NumberToggle()
		if(&relativenumber == 1)
			set nornu
		else
			set rnu
		endif
	endfunc

	" tab-key insert-mode auto-completion
	function! Tab_Or_Complete()
		let colPos = col('.')
		if colPos > 1 && strpart(getline('.'), colPos - 2, 3) =~ '^\w'
			return "\<c-n>"
		else
			return SmartTab(colPos)
		endif
	endfunction

	" if any preceding characters are only spaces or tabs, insert a hard tab
	" otherwise, insert a soft tab
	func! SmartTab(colPos)
		let currLn = getline(".")
		if a:colPos == 1 || currLn[:a:colPos - 2] =~ "^[\t]*$"
			return "\<tab>"
		else
			return repeat(" ", &tabstop - (virtcol(".") - 1) % &tabstop)
		endif
	endfunc

	" if cursor position is preceded by multiple spaces, delete all spaces
	" until the last tab-stop column
	func! SmartBackspace(colPos, virtColPos)
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

	func! BlockSmartTab()
		let lineNr = line(".")
		let colPos = col("'<")

		if len(getline(lineNr)) > 0
			call cursor(lineNr, colPos)
			exec "normal! i" . SmartTab(colPos)
		endif
	endfunc

	func! BlockSmartBackspace()
		let lineNr = line(".")
		let colPos = col("'<")

		if len(getline(lineNr)) > 0
			call cursor(lineNr, colPos)
			exec "normal! i" . SmartBackspace(colPos, virtcol("'<"))
		endif
	endfunc

	" toggles paste setting when pasting from the terminal
	function! SmartPaste()
		set pastetoggle=<esc>[201~
		set paste
		return ""
	endfunction

	" closes any open NERDTree buffers
	function! NERDTreeQuit()
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
	endfunction

	function! TmuxOrSplitSwitch(wincmd, tmuxdir)
		let previous_winnr = winnr()
		silent! execute "wincmd " . a:wincmd
		if previous_winnr == winnr()
			call system("tmux select-pane -" . a:tmuxdir)
		redraw!
		endif
	endfunction

	" open the open C header file's accompanying source file in a split of
	" type typeOfSplit
	func! SplitSource(typeOfSplit)
		exec "normal! :" . a:typeOfSplit . " " . expand("%:p:r") . ".c\<cr>"
	endfunc

	" open the open C source file's accompanying header file in a split of
	" type typeOfSplit
	func! SplitHeader(typeOfSplit)
		exec "normal! :" . a:typeOfSplit . " " . expand("%:p:r") . ".h\<cr>"
	endfunc

	" compile open Sass file
	func! CompileSass()
		exec "!sass ". expand("%:p:") . " " . expand("%:p:r") . ".css"
	endfunc

	" toggle all folding levels (ie fold everything, unfold everything)
	func! ToggleUniversalFold()
		if &foldlevel != 0
			exec "normal! zM"
		else
			exec "normal! zR"
		endif
	endfunc

	" if current file inside a git tree, return the name of the current branch;
	" else, return an empty string
	func! GitBranchName()
		let gitCommand = "cd " . expand("%:p:h") . " && [ -d .git ] ||
			\ git rev-parse --is-inside-work-tree > /dev/null 2>&1 &&
			\ git symbolic-ref --short HEAD 2> /dev/null ||
			\ git rev-parse HEAD | cut -b-10"
		let branchName = system(gitCommand)
		if len(branchName) > 0
			return " " . branchName[:len(branchName) - 2] . "  "
		else
			return ""
		endif
	endfunc

	" load filetype specific template and perform any necessary template flag
	" substitutions
	func! LoadTemplate()
		let templateFileName = glob("~/.dotfiles/vim/templates/" . &filetype . ".tmp")
		if filereadable(templateFileName)
			exe "normal! :read " . templateFileName . "\<cr>"
		else
			return
		endif

		let templateFlags = {
			\"fileBaseName" : "__FILEBASE__",
			\"cursorStart" : "__START__"
		\}

		if search(templateFlags["fileBaseName"]) > 0
			exe "normal! :%s/" . templateFlags["fileBaseName"] .
				\ "/" . expand("%:t:r") . "/g\<cr>"
		endif

		exe "normal! ggdd"
		exe "normal! /__START__\<cr>de"
		startinsert!
	endfunc

	func! EatSpace()
		let c = nr2char(getchar(0))
		return (c == ' ') ? '' : c
	endfunc

	" Show syntax highlighting groups for word under cursor
	func! SynStack()
		if !exists("*synstack")
			return
		endif
		echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
	endfunc

	" statusline for current window split
	func! StatusLine()
		setl statusline=%1*\ %t\                            " filename
		setl stl+=%2*%{&readonly?'\ ':''}                  " readonly

		if !exists("b:gitBranchName")
			let b:gitBranchName = GitBranchName()
		endif

		setl stl+=%3*%{b:gitBranchName}                     " branch name
		setl stl+=%4*%{&modified?' +\ ':''}                 " modified (note unicode space)
		setl stl+=%5*%=                                     " right justify
		setl stl+=%6*\ %{strlen(&ft)?&ft:'none'}\           " filetype
		setl stl+=%7*\ %p%%\                                " percent of file
	endfunc

	" statusline for other window splits
	func! StatusLineNC()
		setl statusline=%1*\ %t\                            " filename
		setl stl+=%4*%{&modified?'\ +\ ':''}                " modified
		setl stl+=%5*%=                                     " right justify
	endfunc

	call StatusLine()
