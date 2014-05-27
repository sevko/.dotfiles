" default

	" This line should not be removed as it ensures that various options are
	" properly set to work with the Vim-related packages available in Debian.
	runtime! debian.vim

	call pathogen#infect('bundle/{}') | call pathogen#helptags()

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
		set background=dark
		silent! colorscheme solarized

	set runtimepath+=~/.dotfiles/vim/

	set showcmd
	set autowrite
	set ttyfast lazyredraw

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
	set scrolloff=25
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
	set pumheight=10

	set list lcs=tab:\·\ 
	set iskeyword+=-

	" italic comments
		highlight Comment cterm=italic
		set t_ZH=[3m
		set t_ZR=[23m

	" UltiSnips
		let g:UltiSnipsExpandTrigger = "<c-j>"
		let g:UltiSnipsJumpForwardTrigger = "<c-j>"
		let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
		let g:UltiSnipsSnippetDirectories = ["ultisnips"]

	" NERDTree
		" key-maps
		let NERDTreeMapOpenSplit="s"
		let NERDTreeMapOpenVSplit="v"

		let NERDTreeMapActivateNode="h"
		let NERDTreeMapToggleHidden="<c-h>"

		let NERDTreeMapJumpFirstChild="<leader>k"
		let NERDTreeMapJumpLastChild="<leader>j"

		let NERDTreeWinSize=24

	" NERDCommenter
		let NERDSpaceDelims = 1
		let g:NERDCustomDelimiters = {
			\ 'c': { 'left': '//', 'right': '',
				\ 'leftAlt': '/*','rightAlt': '*/' },
			\ 'cpp': { 'left': '//', 'right': '',
				\ 'leftAlt': '/*','rightAlt': '*/' },
			\ 'graphicscript' : { 'left' : '#'},
			\ "mdl" : { "left" : '//' }
		\}

	" smart pasting
		let &t_SI .= "\<esc>[?2004h"
		let &t_EI .= "\<esc>[?2004l"

	" tmux/vim pane navigation
		let previous_title = substitute
			\(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
		let &t_ti = "\<esc>]2;vim\<esc>\\" . &t_ti
		let &t_te = "\<esc>]2;". previous_title . "\<esc>\\" . &t_te

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
	hi NonText ctermbg=15
	hi Search ctermbg=1 ctermfg=8
	hi SpellBad cterm=none ctermfg=1

	hi statusline cterm=none ctermbg=235
	hi statuslinenc ctermfg=none ctermbg=235

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
		" highlighting for status line components
		hi User1 ctermfg=231 ctermbg=31
		hi User2 ctermfg=160 ctermbg=31
		hi User3 ctermfg=22 ctermbg=118

		hi User4 ctermfg=231 ctermbg=1
		hi User5 cterm=none ctermbg=235
		hi User6 ctermfg=231 ctermbg=31
		hi User7 cterm=bold ctermfg=234 ctermbg=253

	hi MatchParen cterm=bold ctermfg=45 ctermbg=none
	hi _extraWhitespace ctermbg=88 | match _extraWhitespace /\s\+$/

" autocommands

	augroup miscellaneous
		au!
		au WinEnter * call NERDTreeQuit()
		au WinEnter,BufRead,BufNewFile * call StatusLine()
		au WinLeave * call StatusLineNC()

		au bufnewfile * call LoadTemplate()

		au BufRead,BufNewFile *.tmp set filetype=template
		au BufRead,BufNewFile *.gsc set filetype=graphicscript
		au BufRead,BufNewFile *.mdl set filetype=mdl
		au BufRead *.val set filetype=valgrind
		au BufReadPost ~/.vimrc exe "normal! zM"
		au BufWritePost ~/.vimrc source ~/.vimrc

		au BufWinEnter,InsertLeave * match _extraWhitespace /\s\+$/
		au InsertEnter * match _extraWhitespace /\s\+\%#\@<!$/
		au InsertEnter,WinLeave * :set nornu
		au InsertLeave,WinEnter * :call RelativeNumber()

		au InsertEnter * set timeoutlen=140
		au InsertLeave * set timeoutlen=280

		au FileType modula2 set filetype=markdown
		au FileType html set filetype=htmldjango
		au BufRead *.json set filetype=javascript.json
	augroup END

" commands

	com! OpenFtpluginFile exe "normal! :tabe $HOME/.dotfiles/vim/ftplugin/" .
		\ &ft . ".vim\<cr>"
	com! OpenUltiSnipsFile exe "normal! :tabe $HOME/.dotfiles/vim/ultisnips/" .
		\ &ft . ".snippets\<cr>"

" key mappings

	let mapleader = " "

	" global

		norem <f1> :NERDTreeToggle<cr>

		map <leader>c <plug>NERDCommenterToggle
		map <leader>cz <plug>NerdComComment

	" normal

		nnorem <leader>ev :tabf $MYVIMRC<cr>
		nnorem <leader>ef :OpenFtpluginFile<cr>
		nnorem <leader>eu :OpenUltiSnipsFile<cr>

		nnorem <leader>w <esc>:w<cr>
		nnorem <leader>q <esc>:q<cr>
		nnorem <leader>wq <esc>:wq<cr>
		nnorem <leader>fq <esc>:q!<cr>
		nnorem <leader>wa <esc>:wa<cr>

		" Faster navigation
			nnorem H b
			nnorem L w
			nnorem J 4j
			nnorem K 4k
			nnorem <leader>l $
			nnorem <leader>h ^
			nnorem <leader>j G
			nnorem <leader>k gg

		nnorem <leader>n :call NumberToggle()<cr>
		nnorem <tab> .
		nnorem = =<cr>
		nnorem f za
		nnorem F :call ToggleUniversalFold()<cr>
		nnorem <c-f> zO
		nnorem <c-c> zC
		nnorem <leader>t :tabnext<cr>
		nnorem <leader>st :tabprev<cr>

		nnorem <leader>r :call RotateWindows()<cr>
		nnorem sv :source ~/.vimrc<cr>
		nnorem ss :sp <c-d>
		nnorem vv :vsp <c-d>

		nnorem b <c-v>
		nnorem <leader>rt :call HardRetab("soft")<cr>
		nnorem tt :tabe 

		nnorem <up> <esc>:call ResizeUp()<cr>
		nnorem <down> <esc>:call ResizeDown()<cr>
		nnorem <left> <esc>:call ResizeLeft()<cr>
		nnorem <right> <esc>:call ResizeRight()<cr>

		nnorem <tab> >>
		nnorem <s-tab> <<

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

		" Faster navigation
			onorem H b
			onorem L w
			onorem J 4j
			onorem K 4k
			onorem <leader>l $
			onorem <leader>h ^
			onorem <leader>j G
			onorem <leader>k gg

	" insert

		" Map all alphanumeric keys to trigger the completion-menu popup in
		" insert mode.
			let char_nums = range(char2nr("0"), char2nr("9"))
			let char_nums += range(char2nr("A"), char2nr("Z"))
			let char_nums += range(char2nr("a"), char2nr("z"))

			for char_num in char_nums
				let char = nr2char(char_num)
				silent! exec "inoremap <silent> " . char . " " . char .
					\ "<c-n><c-p>"
			endfor

		inorem <special><expr> <esc>[200~ SmartPaste()

		"Scroll up/down auto-complete menu with j/k
			im <F2> <plug>NERDCommenterInsert
			inorem <expr> J ((pumvisible())?("\<c-n>\<c-n>\<c-n>"):("J"))
			inorem <expr> K ((pumvisible())?("\<c-p>\<c-p>\<c-p>"):("K"))

		inorem jj j
		inorem kk k

		inorem <tab> <c-r>=Tab_Or_Complete()<cr>
		inorem <s-tab> <c-p>
		inorem <bs> <c-r>=SmartBackspace(col("."), virtcol("."))<cr>
		inorem <space> <c-r>=UltiSnipExpand()<cr>

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
		inorem ( ()<left>
		inorem (( ()
		inorem [ []<left>
		inorem [[ []
		inorem {{ {}<left>
		inorem { {<cr>}<esc>O

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

" functions

	" toggles between relative and absolute line numbering
	function! NumberToggle()
		if !&number
			return
		endif

		if(&relativenumber)
			set nornu
		else
			set rnu
		endif
	endfunc

	" if line-numbering enabled, set relative-line-numbering; used by
	" window-movement autocommand
	func! RelativeNumber()
		if &nu
			setl rnu
		endif
	endfunc

	" indent a block of text in visual mode, then restore the visual selection
	" shifted right by the indentation width.
	func! VisualIndent()
		let start_line = line("'<")
		let end_line = line("'>")

		for line in range(start_line, end_line)
			silent! exec "normal! " . line . "gg>>"
		endfor
		exec "normal! l" . start_line . "gg\<c-v>" . end_line . "gg"
	endfunc

	" deindent a block of text in visual mode, then restore the visual selection
	" shifted left by the indentation width.
	func! VisualDeindent()
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

	" toggles paste setting when pasting from the terminal
	function! SmartPaste()
		set pastetoggle=<esc>[201~
		set paste
		return ""
	endfunction

	" If a NERDTree buffer is open, close it, rotate panes, and then reopen
	" it; otherwise, just rotate the splits.
	func! RotateWindows()
		if NERDTreeAnyBuffers()
			let toggle_tree = ":NERDTreeToggle\<cr>"
			exec "normal! " . toggle_tree ":wincmd r\<cr>" . toggle_tree
		else
			exec "normal! :wincmd r\<cr>"
		endif
	endfunc

	" closes any open NERDTree buffers
	func! NERDTreeQuit()
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

	func! NERDTreeAnyBuffers()
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

		return windowfound
	endfunc

	" facilitates seamless navigation across tmux/vim splits with a single set
	" of keymaps
	function! TmuxOrSplitSwitch(wincmd, tmuxdir)
		let previous_winnr = winnr()
		silent! execute "wincmd " . a:wincmd
		if previous_winnr == winnr()
			call system("tmux select-pane -" . a:tmuxdir)
		redraw!
		endif
	endfunction

	func! HardRetab(tab_type)
		let soft_tab = repeat(" ", &tabstop)

		if a:tab_type == "soft"
			let soft_tab_regex = "\\(^\\(" . soft_tab . "\\)*\\)\\@<=" .
				\ soft_tab
			silent! exec "normal! :%s/" . soft_tab_regex . "/\t/g\<cr>``"
		elseif a:tab_type == "hard"
			let hard_tab_regex = "\\(^[\t]*\\)\\@<=\t"
			silent! exec "normal! :%s/" . hard_tab_regex . "/" . soft_tab .
				\ "/g\<cr>``"
		endif
	endfunc

	" toggle all folding levels (ie fold everything, unfold everything)
	func! ToggleUniversalFold()
		set foldmethod=indent
		if &foldlevel != 0
			exec "normal! zM"
		else
			exec "normal! zR"
		endif
	endfunc

	func! EscapeAbbreviation()
		if col(".") == len(getline("."))
			exe "normal! xa "
		else
			exe "normal! xi "
		endif
	endfunc

	" if current file inside a git tree, return the name of the current branch;
	" else, return an empty string
	func! GitBranchName()
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

	" load filetype specific template and perform any necessary template flag
	" substitutions
	func! LoadTemplate()
		let templateFileName = glob("~/.dotfiles/vim/templates/" . &filetype .
			\ ".tmp")
		let altTemplateFileName = glob("~/.dotfiles/vim/templates/" .
			\ &filetype . "_" . expand("%:e") . ".tmp")

		if filereadable(templateFileName)
			exe "normal! :read " . templateFileName . "\<cr>"
		elseif filereadable(altTemplateFileName)
			exe "normal! :read " . altTemplateFileName . "\<cr>"
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
		silent! exe "normal! /__START__\<cr>de"
		startinsert!
	endfunc

	" Attempt to expand an UltiSnip snippet; on failure, return " ";
	" otherwise, "".
	func! UltiSnipExpand()
		if <SNR>13_IsCommentedNormOrSexy(line("."))
			return " "
		else
			call UltiSnips#ExpandSnippet()
			return (g:ulti_expand_res == 0)?" ":""
		endif
	endfunc

	" deletes the preceding space; used by abbreviations
	func! EatSpace()
		let c = nr2char(getchar(0))
		return (c == " ")?"":c
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
		setl statusline=%1*\ %t\ " filename
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

	" statusline for other window splits
	func! StatusLineNC()
		setl statusline=%1*\ %t\  " filename
		setl stl+=%4*%{&modified?'\ +\ ':''} " modified
		setl stl+=%5*%= " right justify
	endfunc

	call StatusLine()
