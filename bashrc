# aliases
	alias tmux="TERM=screen-256color-bce tmux"

# functions/conditionals
	if [ "$TMUX" = "" ]
		then tmux attach || tmux new
	fi
