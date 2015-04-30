export PS1="[01m$[00m "
alias tmux="TERM=screen-256color-bce tmux"

if [ "$(ps -al | grep tmux )" = "" ]
	then tmux attach || tmux new
fi
