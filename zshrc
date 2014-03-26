source ~/.dotfiles/zsh/oh-my-zsh.zsh
source ~/.dotfiles/zsh/prompt.zsh

# settings
	setopt extendedglob
	zstyle ':completion:*' menu select
	zstyle ':completion:*:processes-names' command 'ps -e -o comm='
	COMPLETION_WAITING_DOTS="true"
	DISABLE_UNTRACKED_FILES_DIRTY="true"

	export PATH=$PATH:~/.dotfiles/shell_scripts
	export EDITOR=vim

#(zsh) hotkeys
	stty intr \^x
	bindkey -v "^r" history-incremental-search-backward

#aliases
	alias bpy="bpython -q"
	alias ccat="pygmentize -O style=monokai -f terminal -g"
	alias clip="xclip -select clipboard"
	alias ev=evince
	alias gcc="gcc -Wall -Wextra -Wpointer-arith -Wcast-align -Wunreachable-code"
	alias gth=gthumb
	alias hp-scan="echo 'nope nope nope'"
	alias ka=killall
	alias memcheck="valgrind --leak-check=yes --show-reachable=yes\
		--num-callers=20 --track-fds=yes --track-origins=yes"
	alias nyan="nc -v nyancat.dakko.us 23"
	alias py=python
	alias scan="command hp-scan --area=0,0,216,279"
	alias so=source
	alias sasw="sass --watch"
	alias soz="source ~/.zshrc"
	alias t="command tmux"
	alias tmux="TERM=screen-256color-bce tmux"
	alias v=vim

	# core utils
		alias c=cd
		alias l="command ls --color -h --group-directories-first"
		alias ll="l -al"
		alias m=man
		alias mk="make -j"
		alias mkd=mkdir
		alias wg=wget

	# git
		alias g=git
		alias ga="git add"
		alias gau="git add -u"
		alias gb="git branch"
		alias gba="git branch -a"
		alias gbd="git branch -d"
		alias gbm="git branch --merged"
		alias gbnm="git branch --no-merged"
		alias gc="git commit"
		alias gcl="git clone"
		alias gco="git checkout"
		alias gcob="git checkout -b"
		alias gd="git diff"
		alias gf="git fetch"
		alias gi="git init"
		alias gl="git log"
		alias gm="git merge"
		alias gp="git pull"
		alias gpu="git push"
		alias gpuo="git push origin"
		alias grh="git reset HEAD"
		alias grhh="git reset --hard HEAD"
		alias grm="git rm"
		alias gs="git status"
		alias gst="git stash"
		alias gsta="git stash apply"
		alias gstl="git stash list"
		alias gsu="git submodule"
		alias gu="git up"

# variables
	export EDITOR=vim
	export PROMPT_DIRTRIM=3

# functions & conditionals

	if [[ -s '/etc/zsh_command_not_found' ]]; then
		source '/etc/zsh_command_not_found'
	fi

	gpub(){
		git push --set-upstream origin $(git symbolic-ref --short HEAD)
	}

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
