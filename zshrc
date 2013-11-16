# oh-my-zsh

	ZSH=$HOME/.oh-my-zsh  # Path to your oh-my-zsh configuration.

	# Set name of the theme to load.
	# Look in ~/.oh-my-zsh/themes/
	# Optionally, if you set this to "random", it'll load a random theme each
	# time that oh-my-zsh is loaded.
	#ZSH_THEME="norm"

	# Example aliases
	# alias zshconfig="mate ~/.zshrc"
	# alias ohmyzsh="mate ~/.oh-my-zsh"

	# Set to this to use case-sensitive completion
	CASE_SENSITIVE="true"

	# Uncomment this to disable bi-weekly auto-update checks
	# DISABLE_AUTO_UPDATE="true"

	# Uncomment to change how often before auto-updates occur? (in days)
	# export UPDATE_ZSH_DAYS=13

	# Uncomment following line if you want to disable colors in ls
	# DISABLE_LS_COLORS="true"

	# Uncomment following line if you want to disable autosetting terminal title.
	# DISABLE_AUTO_TITLE="true"

	# Uncomment following line if you want to disable command autocorrection
	# DISABLE_CORRECTION="true"

	# Uncomment following line if you want red dots to be displayed while waiting for completion
	COMPLETION_WAITING_DOTS="true"

	# Uncomment following line if you want to disable marking untracked files under
	# VCS as dirty. This makes repository status check for large repositories much,
	# much faster.
	# DISABLE_UNTRACKED_FILES_DIRTY="true"

	# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
	# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
	# Example format: plugins=(rails git textmate ruby lighthouse)
	plugins=(git last-working-dir)

	source $ZSH/oh-my-zsh.sh

	# Customize to your needs...
	export PATH=$PATH:/home/sevko/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

#bash hotkeys
	stty intr \^x

#aliases
	alias v=vim
	alias ka=killall
	alias clip="xclip -select clipboard"
	alias ls="ls --color -h --group-directories-first"	# user variables
	alias ccat="pygmentize -O style=monokai -f terminal -g"
	alias hp-scan="hp-scan --area=0,0,216,279"
	alias tmux="TERM=screen-256color-bce tmux"

	alias g="git"
	alias gs="git status"
	alias gpu="git pull"

# variables
	marge="severyn.kozak@marge.stuy.edu"
	orca="sevko@orca.elee.me"
	droplet="root@162.243.33.238"
	stuybooks="root@162.243.33.238:/var/www/FlaskApp/FlaskApp"

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
