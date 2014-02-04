source ~/.dotfiles/zsh/prompt.zsh

# settings
	zstyle ':completion:*' menu select list-colors ''
	CASE_SENSITIVE="true"
	COMPLETION_WAITING_DOTS="true"
	DISABLE_UNTRACKED_FILES_DIRTY="true"

	export PATH=$PATH:/home/sevko/.local/bin:/usr/local/sbin:/usr/local/bin
	export PATH=$PATH:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

#(zsh) hotkeys
	stty intr \^x
	bindkey "^R" history-incremental-search-backward


#aliases
	alias bpy=bpython
	alias ccat="pygmentize -O style=monokai -f terminal -g"
	alias clip="xclip -select clipboard"
	alias ev=evince
	alias gth=gthumb
	alias ka=killall
	alias memcheck="valgrind --leak-check=yes --show-reachable=yes
		--num-callers=20 --track-fds=yes --track-origins=yes"
	alias scan="command hp-scan --area=0,0,216,279"
	alias hp-scan="echo 'nope nope nope'"
	alias so=source
	alias sasw="sass --watch"
	alias soz="source ~/.zshrc"
	alias t=tmux
	alias v=vim

	# core utils
		alias c=cd
		alias l="command ls --color -h --group-directories-first"
		alias ll="ls -al"
		alias m=man
		alias mk=make
		alias mkd=mkdir
		alias wg=wget

	# git
		alias g=git
		alias ga="git add"
		alias gau="git add -u"
		alias gb="git branch"
		alias gc="git commit"
		alias gcl="git clone"
		alias gco="git checkout"
		alias gd="git diff"
		alias gf="git fetch"
		alias gl="git log"
		alias gm="git merge"
		alias gp="git pull"
		alias gpu="git push"
		alias grh="git reset --hard HEAD"
		alias gs="git status"
		alias gst="git stash"
		alias gsta="git stash apply"
		alias gstl="git stash list"
		alias gu="git up"

# variables
	export EDITOR=vim
	export PROMPT_DIRTRIM=3

# functions & conditionals

	if [[ -s '/etc/zsh_command_not_found' ]]; then
		source '/etc/zsh_command_not_found'
	fi

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
