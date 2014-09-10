# settings
	setopt extendedglob
	setopt GLOB_COMPLETE

	# completion
		autoload -Uz compinit
		compinit

		zstyle ":completion:*" menu select=2
		zstyle ":completion:*" verbose yes
		zstyle ":completion:*:processes-names" command "ps -e -o comm="
		zstyle ":completion:*:*:vim:*" ignored-patterns "*.(o|pyc)"
		zstyle ":completion:*:*:pylint:*" file-patterns "*.py"

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

	source $DOT/prompt.zsh
	eval $(dircolors $DOT/dircolors)

	fpath=($HOME/.dotfiles/zsh/ $fpath)

	PATH=$PATH:~/.dotfiles/shell_scripts
	EDITOR=vim
	KEYTIMEOUT=1
	COMPLETION_WAITING_DOTS="true"
	DISABLE_UNTRACKED_FILES_DIRTY="true"

	stty intr \^x
	bindkey -v "^r" history-incremental-search-backward

# aliases
	alias workflowy="/opt/google/chrome/google-chrome \
		--profile-directory=Default --app-id=koegeopamaoljbmhnfjbclbocehhgmkm"
	alias bpy=bpython
	alias ccat="pygmentize -O style=monokai -f terminal -g"
	alias clip="xclip -select clipboard"
	alias com=command
	alias ev=evince
	alias gcc="gcc -Wall -Wextra"
	alias gth=gthumb
	alias jsw="jekyll serve --watch"
	alias ka=killall
	alias keepass="keepassx ~/.keepassx/.passwords.kdb"
	alias memcheck="valgrind --leak-check=yes --show-reachable=yes\
		--num-callers=20 --track-fds=yes --track-origins=yes"
	alias nyan="nc -v nyancat.dakko.us 23"
	alias py=python
	alias pylint="pylint --reports=n --indent-string='\t'\
		--output-format=colorized"
	alias scan="command hp-scan --area=0,0,216,279 --mode=color"
	alias sasw="sass --watch"
	alias sdcv="sdcv --data-dir ~/.stardict"
	alias so=source
	alias soz="source ~/.zshrc"
	alias sudo="nocorrect sudo "
	alias t="command tmux"
	alias tmux="TERM=screen-256color-bce tmux"
	alias uz=unzip
	alias v="vim -p"

	# apt-get
		alias agi="sudo apt-get -y install"
		alias agu="sudo apt-get update"
		alias agr="sudo apt-get remove"
		alias agrp="sudo apt-get remove --purge"
		alias acs="sudo apt-cache search"

	# core utils
		alias c=cd
		alias l="ls --color=auto -h --group-directories-first -p"
		alias ll="l -al"
		alias m=man
		alias mk="make -j"
		alias mkd=mkdir
		alias rmd=rmdir
		alias rmrf="rm -rf"
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
		alias gc="git commit --verbose"
		alias gcl="git clone"
		alias gco="git checkout"
		alias gcob="git checkout -b"
		alias gd="git diff"
		alias gf="git fetch"
		alias gi="git init"
		alias gm="git merge --no-ff"
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
	export TMPDIR=/tmp
	export PROMPT_DIRTRIM=3
	export SDCV_PAGER=less
	export PAGER=less
	export LESS="-RSc"

# functions & conditionals
	gdsu(){
		# Delete a git submodule's files and metadata.
		#
		# use: gdsu SUBMODULE_NAME
		# args:
		#   SUBMODULE_NAME : The name of the submodule to delete.

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
		rm -rf $1
	}

	gpub(){
		# Push the current git branch to the remote.
		#
		# use: gpub

		git push --set-upstream origin $(git symbolic-ref --short HEAD)
	}

	gbda(){
		# Delete a branch, locally and remotely.
		#
		# use: gbda GIT_BRANCH_NAME
		# args:
		#   GIT_BRANCH_NAME : The name of the branch to delete.

		git branch -d $1
		if [ "$(git branch -a --no-color | \
			pcregrep -M "remotes/origin/$1\n")" ]; then
			git push origin --delete $1
		fi
	}

	gl(){
		# Heavily formatted `git log` wrapper.
		#
		# use: gl [GIT_LOG_ARGS]
		# Args:
		#   GIT_LOG_ARGS : Any arguments to `git log`.

		git_log_format="%C(1)[ %h ]%Creset %C(3)%an%Creset "
		git_log_format="$git_log_format%C(2)%cr%Creset %C(6)%s%Creset"
		git log --pretty=format:$git_log_format $*
	}

	cc(){
		# Compile the argument C file into an executable with the same root name.
		#
		# use: cc *COMPILER_OPTIONS C_SOURCE_FILE
		# args:
		#   *COMPILER_OPTIONS : Options passed to the compiler.
		#   C_SOURCE_FILE : The C file to compile.

		gcc $* -o ${*[-1]%.c}
	}

	add_host(){
		# Add a new host entry to ~/.ssh/config.
		#
		# use: add_host HOST HOSTNAME USER
		# args:
		#   HOST : The host's identifying name.
		#   HOSTNAME : The IP address/hostname of the server.
		#   USER : The user's account username on HOSTNAME.

		if [[ $# != 3 ]]; then
			echo "add_host HOST HOSTNAME USER"
		else
			echo "\nHost $1\n\tHostname $2\n\tUser $3" >> ~/.ssh/config
		fi
	}

	def(){
		# Wrapper for `sdcv` that colorizes its output.
		#
		# use: def WORD
		#   WORD (str) : The word to search for with `sdcv`.

		if [[ $# != 1 ]]; then
			echo "Missing argument."
		else
			if [[ "$(sdcv -n $1)" =~ '^Nothing similar to ' ]]; then
				echo "No match for '$1' found."
			else
				sdcv -n $1 | remark ~/.dotfiles/zsh/remark_syntax/sdcv.remark \
					| less
			fi
		fi
	}

	if [[ -s "/etc/zsh_command_not_found" ]]; then
		source "/etc/zsh_command_not_found"
	fi

	if [ "$(ps -al | grep tmux )" = "" ]
		then tmux attach || tmux new
	fi

	# completion
		compctl -K _gdsu_compl gdsu
		compctl -K _git_branch_compl gbda
		compctl -K _git_branch_compl gbd
		compctl -K _eject_compl eject
		compctl -K _gco_compl gco

		_gdsu_compl(){
			# Git submodule name completion for `gdsu()`.

			submodules="$(cat .gitmodules |\
				grep -Po '(?<=submodule \").*(?=\")')"
			reply=("${(f)${submodules}}")
		}

		_eject_compl(){
			# "/media/$USER" sub-directory name completion for `eject`.

			ejectable_devices="$(ls /media/$USER)"
			reply=("${(f)${ejectable_devices}}")
		}

		_gco_compl(){
			# Git branch-name and modified file-path completion for `gco`.

			_git_branch_compl

			modified_files=(
				"${(f)$(git status --porcelain |\
				sed "/^ M /!d" |\
				sed "s/^ M //g")}"
			)
			reply=($reply $modified_files)
		}

		_git_branch_compl(){
			# Git branch-name completion.

			reply=(
				"${(f)$(git branch --no-color | sed "/^* .*/d" | tr -d "^  ")}"
			)
		}

# The following lines were added by zsh-newuser-install
	HISTFILE=~/.histfile
	HISTSIZE=9000
	SAVEHIST=9000
	bindkey -v
	# End of lines configured by zsh-newuser-install
	# The following lines were added by compinstall
	zstyle :compinstall filename '/home/sevko/.zshrc'

	# End of lines added by compinstall
