# bash settings

	#bash hotkeys
		stty intr \^x

# aliases
	alias v="vim"
	alias g="git"
	alias clip="xclip -select clipboard"	# clipboard
	alias ls="ls --color -h --group-directories-first"	# user variables
	alias ccat="pygmentize -O style=monokai -f terminal -g"
	alias hp-scan="hp-scan --area=0,0,216,279"
	alias tmux="TERM=screen-256color-bce tmux"
	alias ka="killall"
	 
	 #SSH  
		marge="severyn.kozak@marge.stuy.edu"
		orca="sevko@orca.elee.me"
		droplet="root@162.243.33.238"
		stuybooks="root@162.243.33.238:/var/www/FlaskApp/FlaskApp"

# bash variables
	export EDITOR=vim
	export PROMPT_DIRTRIM=3

	# Normal Colors
		Black='\e[0;30m'	# Black
		Red='\e[0;31m'		# Red
		Green='\e[0;32m'	# Green
		Yellow='\e[0;33m'	# Yellow
		Blue='\e[0;34m'		# Blue
		Purple='\e[0;35m'	# Purple
		Cyan='\e[0;36m'		# Cyan
		White='\e[0;37m'	# White

	# Bold
		BBlack='\e[1;30m'	# Black
		BRed='\e[1;31m'		# Red
		BGreen='\e[1;32m'	# Green
		BYellow='\e[1;33m'	# Yellow
		BBlue='\e[1;34m'	# Blue
		BPurple='\e[1;35m'	# Purple
		BCyan='\e[1;36m'	# Cyan
		BWhite='\e[1;37m'	# White

	# Background
		On_Black='\e[40m'	# Black
		On_Red='\e[41m'		# Red
		On_Green='\e[42m'	# Green
		On_Yellow='\e[43m'	# Yellow
		On_Blue='\e[44m'	# Blue
		On_Purple='\e[45m'	# Purple
		On_Cyan='\e[46m'	# Cyan
		On_White='\e[47m'	# White
	
	# Misc
		NC="\e[m"	# Color Reset

	if [ -f ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh ]
	then
	  source ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
	fi

	if [ "$TMUX" = "" ]; then tmux; fi
