# aliases
	alias tmux="TERM=screen-256color-bce tmux"

# functions/conditionals
	if [ "$(ps -al | grep tmux )" = "" ]
		then tmux attach || tmux new
	fi
