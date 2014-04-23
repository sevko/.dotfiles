# settings

	setopt extendedglob
	setopt GLOB_COMPLETE

	# completion
		autoload -Uz compinit
		compinit

		zstyle ":completion:*" menu select=2
		zstyle ":completion:*:processes-names" command "ps -e -o comm="

	zmodload zsh/zle
	DOT=$HOME/.dotfiles/zsh/

	# zsh configuration
		ZSH=$DOT/plugins/oh-my-zsh

		DISABLE_AUTO_UPDATE="true"
		COMPLETION_WAITING_DOTS="true"
		DISABLE_UNTRACKED_FILES_DIRTY="true"

		plugins=(last-working-dir pip git-extras)

		if [ -d $ZSH ]; then
			source $ZSH/oh-my-zsh.sh
		fi

		export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:
		/bin:/usr/games:/usr/local/games:/home/sevko/.local/bin:/usr/local/sbin:
		/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:
		/usr/local/games"

	source $DOT/prompt.zsh

	fpath=($HOME/.dotfiles/zsh/ $fpath)

	PATH=$PATH:~/.dotfiles/shell_scripts
	EDITOR=vim
	KEYTIMEOUT=1
	COMPLETION_WAITING_DOTS="true"
	DISABLE_UNTRACKED_FILES_DIRTY="true"

	stty intr \^x
	bindkey -v "^r" history-incremental-search-backward
	# xmodmap -e 'clear Lock' -e 'keycode 0x42 = F10'

#aliases
	alias bpy="bpython -q"
	alias ccat="pygmentize -O style=monokai -f terminal -g"
	alias clip="xclip -select clipboard"
	alias ev=evince
	alias gcc="gcc -Wall -Wextra -Wpointer-arith -Wcast-align \
		-Wunreachable-code"
	alias gth=gthumb
	alias hp-scan="echo 'nope nope nope'"
	alias ka=killall
	alias keepass="keepassx ~/.keepassx/.passwords.kdb"
	alias memcheck="valgrind --leak-check=yes --show-reachable=yes\
		--num-callers=20 --track-fds=yes --track-origins=yes"
	alias nyan="nc -v nyancat.dakko.us 23"
	alias py=python
	alias scan="command hp-scan --area=0,0,216,279"
	alias so=source
	alias sasw="sass --watch"
	alias soz="source ~/.zshrc"
	alias sudo="sudo "
	alias t="command tmux"
	alias tmux="TERM=screen-256color-bce tmux"
	alias v=vim

	# core utils
		alias c=cd
		alias l="ls --color -h --group-directories-first"
		alias ll="l -al"
		alias m=man
		alias mk="make -j"
		alias mkd=mkdir
		alias rmd=rmdir
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

	# Push the current git branch to the remote.
	#
	# use: gpub
	gpub(){
		git push --set-upstream origin $(git symbolic-ref --short HEAD)
	}

	# Delete a git submodule's files and metadata.
	#
	# use: gdsu SUBMODULE_NAME
	# args:
	#   SUBMODULE_NAME - The name of the submodule to delete.
	gdsu(){
		submodule=$1

		test -z $submodule && echo "submodule required" 1>&2 && exit 1
		test ! -f .gitmodules && echo ".gitmodules file not found" 1>&2 \
			&& exit 2

		NAME=$(echo $submodule | sed 's/\/$//g')
		test -z $(git config --file=.gitmodules submodule.$NAME.url) \
			&& echo "submodule not found" 1>&2 && exit 3

		git config --remove-section submodule.$NAME
		git config --file=.gitmodules --remove-section submodule.$NAME
		git rm --cached $NAME
	}

	# Compile the argument C file into an executable with the same root name.
	#
	# use: cc C_SOURCE_FILE
	# args:
	#   C_SOURCE_FILE The C file to compile
	cc(){
		gcc $1 -o ${1%c}
	}

	# Add a new host entry to ~/.ssh/config.
	#
	# use: add_host HOST HOSTNAME USER
	# args:
	#   HOST The host's identifying name.
	#   HOSTNAME The IP address/hostname of the server.
	#   USER The user's account username on HOSTNAME.
	add_host(){
		echo "\nHost $1\n\tHostname $2\n\tUser $3" >> ~/.ssh/config
	}

	if [[ -s "/etc/zsh_command_not_found" ]]; then
		source "/etc/zsh_command_not_found"
	fi

	if [ "$TMUX" = "" ]
		then tmux attach || tmux new
	fi

# The following lines were added by zsh-newuser-install
	HISTFILE=~/.histfile
	HISTSIZE=9000
	SAVEHIST=9000
	bindkey -v
	# End of lines configured by zsh-newuser-install
	# The following lines were added by compinstall
	zstyle :compinstall filename '/home/sevko/.zshrc'

	# End of lines added by compinstall
