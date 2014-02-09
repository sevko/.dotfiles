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
		execute "set <S-Up>=\e[1;2A"
		execute "set <S-Down>=\e[1;2B"
		execute "set <S-Right>=\e[1;2C"
		execute "set <S-Left>=\e[1;2D"
	endif

" settings

	filetype indent on
	filetype plugin on

	" colorscheme
		set background=dark
		colorscheme solarized

	set showcmd
	set autowrite

	" file backup
		" backup to ~/.tmp; get rid of .swp files
		set backup
		set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
		set backupskip=/tmp/*,/private/tmp/*
		set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
		set writebackup

	set number
	set nowrap
	set linebreak

	set timeoutlen=280
	set colorcolumn=81
	set scrolloff=25 sidescrolloff=40
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

	" statusline

		" highlighting for status line components
		hi User1 cterm=bold ctermfg=231 ctermbg=31
		hi User2 ctermfg=160 ctermbg=31
		hi User3 ctermfg=22  ctermbg=118

		hi User4 ctermfg=231 ctermbg=1
		hi User5 cterm=none ctermbg=235
		hi User6 ctermfg=231 ctermbg=31
		hi User7 cterm=bold ctermfg=234 ctermbg=253

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

	" smart pasting
		let &t_SI .= "\<Esc>[?2004h"
		let &t_EI .= "\<Esc>[?2004l"

	" tmux/vim pane navigation
		let previous_title = substitute
			\(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
		let &t_ti = "\<Esc>]2;vim\<Esc>\\" . &t_ti
		let &t_te = "\<Esc>]2;". previous_title . "\<Esc>\\" . &t_te

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

	hi MatchParen cterm=bold ctermfg=45 ctermbg=none

" autocommands

	augroup window
		au!
		au WinEnter                             *       call NERDTreeQuit()
		au WinEnter,BufRead         * call StatusLine()
		au WinLeave         *       call StatusLineNC()
	augroup END

	augroup new_buffer
		au!
		au bufnewfile       *.java  :0r ~/.dotfiles/vim/templates/java.txt
							\| exe "normal! gg2e2li" . expand("%:t:r")
							\. " \<Esc> 2ji" .	expand("%:t:r")
							\. "() \<Esc>oa\<BS>"

		au bufnewfile       *.html  :0r~/.dotfiles/vim/templates/html.txt
		au bufnewfile       *.c     :0r ~/.dotfiles/vim/templates/c.txt

		au bufnewfile       *       exe "normal Gddk"
		au bufnewfile       *       startinsert

		au bufnewfile       *.java  exe "normal! k$"
	augroup END

	augroup file_specific
		au!
		au BufReadPost      ~/.vimrc         exe "normal! zM"
		au BufWritePost     ~/.vimrc            source ~/.vimrc
	augroup END

	augroup universal
		"au FileType         *      call <SID>def_base_syntax()
		autocmd InsertEnter *       hi clear extraWhiteSpace
		autocmd InsertLeave *       hi extraWhiteSpace cterm=none ctermbg=88
			\ | match extraWhiteSpace /\s\+$/
	augroup END

	augroup filetype_vim
		au!
		au FileType vim    inoremap  <buffer>  func
			\ func!<space><cr>endfunc<Esc><Up>$a
		au FileType vim    inoremap  <buffer>  if
			\ if<cr>endif<Esc>k$a<space>
		au FileType vim    inoremap  <buffer>  while
			\ while<cr>endwhile<Esc>k$a<space>
		au FileType vim    inoremap  <buffer>  augroup
			\ augroup<cr>au!<cr>augroup END<Esc>2k$a<space>
		au FileType vim    iabbrev    <buffer> func
			\ func!<space><cr>endfunc<Esc><Up><Up>$a
	augroup END

	augroup filetype_sh
		au!
		au FileType sh      inoremap    <buffer>  if
			\if<cr>then<cr>fi<Esc>2k$a<space>
		au FileType sh      inoremap    <buffer>  for
			\for<cr>do<cr>done<Esc>2k$a<space>
		au FileType sh      inoremap    <buffer>  while
			\while<cr>do<cr>done<Esc>2k$a<space>
	augroup END

	augroup filetype_html
		au!
		au FileType html,htmldjango     setlocal tabstop=2 shiftwidth=2
		au FileType html,htmldjango     inoremap <buffer>   <   <><Left>
		au FileType html,htmldjango     inoremap <buffer>   %
			\ %<Space><Space>%<Left><Left>
		au FileType html,htmldjango     inoremap <buffer>   %%  %
	augroup END

	augroup filetype_java
		au!
		au FileType java    inoreabbrev  <buffer>   psvm
			\ public static void main(String[] args){<cr>}<Esc>O
		au FileType java    nnoremap <buffer>   <leader>;   $a;<esc>o
		au FileType java    inoreabbrev <buffer>   if          if()<Left>
		au FileType java    inoreabbrev <buffer>   for         for(;;)<Left><Left><Left>
		au FileType java    inoreabbrev <buffer>   while       while()<Left>
	augroup END

	augroup filetype_c
		au!
		au FileType c,cpp inoremap <buffer> if          if()<Left>
		au FileType c,cpp inoremap <buffer> for         for(;;)<Left><Left><Left>
		au FileType c,cpp inoremap <buffer> while       while()<Left>
		au Filetype c,cpp iabbrev  <buffer> #i          #include
		au Filetype c,cpp iabbrev  <buffer> #d          #define
		au FileType c,cpp nnoremap <buffer> <leader>;   $a;<esc>
		au Filetype c,cpp nnoremap <buffer> <leader>oh  :call SplitHeader("vsplit")<cr>
		au Filetype c,cpp nnoremap <buffer> <leader>oc  :call SplitSource("vsplit")<cr>
		au Filetype c,cpp nnoremap <buffer> <leader>ohs  :call SplitHeader("split")<cr>
		au Filetype c,cpp nnoremap <buffer> <leader>ocs  :call SplitSource("split")<cr>
	augroup END

	augroup filetype_js
		au!
		au FileType javascript nnoremap <buffer> <leader>;   $a;<esc>o
	augroup END

	augroup sass
		au!
		au Filetype sass nnoremap <buffer> <leader>cs   :call CompileSass()<cr>
	augroup END

	augroup filetype_text
		au!
		au Filetype gitcommit   setlocal spell textwidth=80
		au Filetype markdown    setlocal spell textwidth=80
		au FileType text        setlocal spell textwidth=80
	augroup END

	augroup filetype_sh
		au!
		au FileType sh      inoreabbrev <buffer>    if
			\ if<space>[ ]<cr>then<cr>fi<Esc>2<Up>3<Right>i
	augroup END

	augroup relativeLnNum
		au!
		au InsertEnter      *   :set number
		au InsertLeave      *   :set relativenumber
		au FocusLost        *   :set number
		au FocusGained      *   :set relativenumber
	augroup END

" key mappings

	let mapleader = " "

	" global

		noremap     <F1>        :NERDTreeToggle<cr>

		map         <leader>c   <plug>NERDCommenterToggle
		map         <leader>cz  <plug>NerdComComment

	" normal

		noremap    <leader>ev   :vsplit $MYVIMRC<cr>
		nnoremap   <leader>w    <esc>:w<cr>
		nnoremap   <leader>q    <esc>:q<cr>
		nnoremap   <leader>wq   <esc>:wq<cr>
		nnoremap   <leader>fq   <esc>:q!<cr>
		nnoremap   <leader>wa   <esc>:wa<cr>

		" Faster navigation
		nnoremap    H           b
		nnoremap    L           w
		nnoremap    J           4j
		nnoremap    K           4k
		nnoremap    <leader>l   $
		nnoremap    <leader>h   ^
		nnoremap    <leader>j   G
		nnoremap    <leader>k   gg

		nnoremap    <leader>n   :call NumberToggle()<cr>
		nnoremap    <Tab>       .
		nnoremap    =           =<cr>
		nnoremap    f           za
		nnoremap    F           :call ToggleUniversalFold()<cr>
		nnoremap    <leader>t   :tabnext<CR>
		nnoremap    <leader>st  :tabprev<CR>

		nnoremap    <leader>r   :wincmd r<CR>
		nnoremap    sv          :source ~/.vimrc<cr>
		nnoremap    s           :set 

		nnoremap    <c-a>       ggvG$
		nnoremap    b           <c-v>
		nnoremap    <leader>rt  :retab!<cr>
		nnoremap    tt          :tabf

		" tmux/vim pane navigation
		if exists('$TMUX')
			nnoremap <silent> <C-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
			nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
			nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
			nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>

			nnoremap <C-m-j>        :echo "thirty"
		else
			map <C-h> <C-w>h
			map <C-j> <C-w>j
			map <C-k> <C-w>k
			map <C-l> <C-w>l
		endif

	" operator-pending

		" Faster navigation
		onoremap    H           b
		onoremap    L           w
		onoremap    J           4j
		onoremap    K           4k
		onoremap    <leader>l   $
		onoremap    <leader>h   ^
		onoremap    <leader>j   G
		onoremap    <leader>k   gg

	" insert

		inoremap    <special><expr>         <Esc>[200~ SmartPaste()

		"Scroll up/down auto-complete menu with j/k
		inoremap    <expr> j    ((pumvisible())?("\<C-n>"):("j"))
		inoremap    <expr> k    ((pumvisible())?("\<C-p>"):("k"))
		inoremap    <Tab>       <C-R>=Tab_Or_Complete()<CR>
		inoremap    <BS>        <C-R>=SmartBackspace(col("."), virtcol("."))<CR>
		inoremap    jk          <esc>

		inoremap    "           ""<Left>
		inoremap    '           ''<Left>
		inoremap    ""          "
		inoremap    ''          '
		inoremap    (           ()<Left>
		inoremap    ((          ()
		inoremap    [           []<Left>
		inoremap    [[          []
		inoremap    {{          {}<Left>
		inoremap    {           {<CR>}<Esc>O

		inoremap    <up>        <esc>:call ResizeUp()<cr>
		inoremap    <down>      <esc>:call ResizeDown()<cr>
		inoremap    <left>      <esc>:call ResizeLeft()<cr>
		inoremap    <right>     <esc>:call ResizeRight()<cr>

		imap        <S-up>      <up><up>
		imap        <S-down>    <down><down>
		imap        <S-left>    <left><left>
		imap        <S-right>   <right><right>

		imap        <c-c>       <plug>NERDCommenterInsert

	" visual

		vnoremap jk             <esc>

		" Faster navigation"
		vnoremap    <leader>l   $
		vnoremap    <leader>h   0
		vnoremap    <leader>j   G
		vnoremap    <leader>k   gg
		vnoremap    H           b
		vnoremap    L           w
		vnoremap    J           4j
		vnoremap    K           4k

		vnoremap    <s-tab>     :call BlockSmartBackspace()<cr>gv
		vnoremap    <tab>       :call BlockSmartTab()<cr>gv
		vnoremap    <leader>c   "+y

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
			return "\<C-N>"
		else
			return SmartTab(colPos)
		endif
	endfunction

	" if any preceding characters are only spaces or tabs, insert a hard tab
	" otherwise, insert a soft tab
	func! SmartTab(colPos)
		let currLn = getline(".")
		if a:colPos == 1 || currLn[:a:colPos - 2] =~ "^[\t]*$"
			return "\<Tab>"
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
			return repeat("\<BS>", (a:colPos - startRealIndent))
		else
			return "\<BS>"
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
		set pastetoggle=<Esc>[201~
		set paste
		return ""
	endfunction

	"common operator highlighting
	"function! s:def_base_syntax()
		"let currExt = expand("%:e")

		"" don't apply highlighting for badFiletypes
		"let badFiletypes = ["html"]

		"let toHighlight = 1
		"for fileExt in badFiletypes
			"if fileExt == currExt
				"let toHighlight = 0
				"break
			"endif
		"endfor

		"if toHighlight
			"syntax match operator "()"
			"hi commonOperator ctermfg = red
			"hi baseDelimiter ctermfg = DarkGrey
		"endif
	"endfunction

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
			\ git symbolic-ref --short HEAD"
		let branchName = system(gitCommand)
		if len(branchName) > 0
			return " " . branchName[:len(branchName) - 2] . "  "
		else
			return ""
		endif
	endfunc

	" statusline for current window split
	func! StatusLine()
		setl statusline=%1*\ %t\                        " filename
		setl stl+=%2*%{&readonly?'\ ':''}              " readonly

		if !exists("b:gitBranchName")
			let b:gitBranchName = GitBranchName()
		endif

		setl stl+=%3*%{b:gitBranchName}                 " branch name
		setl stl+=%4*%{&modified?' +\ ':''}             " modified (note unicode space)
		setl stl+=%5*%=                                 " right justify
		setl stl+=%6*\ %{strlen(&ft)?&ft:'none'}\       " filetype
		setl stl+=%7*\ %p%%\                            " percent of file
	endfunc

	" statusline for other window splits
	func! StatusLineNC()
		setl statusline=%1*\ %t\                        " filename
		setl stl+=%4*%{&modified?'\ +\ ':''}            " modified
		setl stl+=%5*%=                                 " right justify
	endfunc

	call StatusLine()
