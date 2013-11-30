# oh-my-zsh

	ZSH=$HOME/.oh-my-zsh  # Path to your oh-my-zsh configuration.

	# Set to this to use case-sensitive completion
	CASE_SENSITIVE="true"

	# Uncomment following line if you want to disable command autocorrection
	# DISABLE_CORRECTION="true"

	# Uncomment following line if you want red dots to be displayed while waiting for completion
	COMPLETION_WAITING_DOTS="true"

	DISABLE_UNTRACKED_FILES_DIRTY="true"

	plugins=(git last-working-dir)

	source $ZSH/oh-my-zsh.sh

	# Customize to your needs...
	export PATH=$PATH:/home/sevko/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

#bash hotkeys
	stty intr \^x

#aliases
	alias v=vim
	alias m=man
	alias bpy='bpython'
	alias ev=evince
	alias so=source
	alias ka=killall
	#alias ev=evince
	alias clip="xclip -select clipboard"
	alias l="command ls --color -h --group-directories-first"
	alias ccat="pygmentize -O style=monokai -f terminal -g"
	alias hp-scan="hp-scan --area=0,0,216,279"
	alias tmux="TERM=screen-256color-bce tmux"

	# core utils
	alias c=cd
	alias wg=wget
	alias mk=make
	alias mkd=mkdir

	# git
	alias g="git"
	alias gau="g add -u"
	alias gc="g commit"
	alias gco="g checkout"
	alias gl="g log"
	alias gp="g pull"
	alias gpu="g push"
	alias grh="git reset --hard HEAD"
	alias gs="g status"

# variables
	export EDITOR=vim
	export PROMPT_DIRTRIM=3

# functions & conditionals

	if [[ -s '/etc/zsh_command_not_found' ]]; then
		source '/etc/zsh_command_not_found'
	fi

	# zsh-powerline-prompt
		fpath+=( ~/.local/lib/zsh-prompt-powerline )
		autoload promptinit ; promptinit

		zstyle ':prompt:*:twilight*'	host-color 093
		zstyle ':prompt:*:pinkie*'		host-color 201
		zstyle ':prompt:*:rarity'		host-color white
		zstyle ':prompt:*:applejack'	host-color 208
		zstyle ':prompt:*:fluttershy'	host-color 226

		zstyle ':prompt:powerline:ps1' sep1-char ''
		zstyle ':prompt:powerline:ps1' sep2-char ''
		zstyle ':prompt:powerline:ps1' lock-char ''
		zstyle ':prompt:powerline:ps1' branch-char ''

		zstyle ':prompt:powerline:ps1' default-sh-level 2
		zstyle ':prompt:powerline:ps1' hide-user 1

		prompt powerline

# The following lines were added by zsh-newuser-install
	HISTFILE=~/.histfile
	HISTSIZE=9000
	SAVEHIST=9000
	bindkey -v
	# End of lines configured by zsh-newuser-install
	# The following lines were added by compinstall
	zstyle :compinstall filename '/home/sevko/.zshrc'

	autoload -Uz compinit
	compinit
	# End of lines added by compinstall
