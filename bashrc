alias tmux="TERM=screen-256color-bce tmux"

if [ "$(ps -al | grep tmux )" = "" ]
	then tmux attach || tmux new
fi

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
