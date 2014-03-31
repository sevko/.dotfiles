# Path to your oh-my-zsh configuration.
ZSH=$HOME/.dotfiles/zsh/plugins/oh-my-zsh

DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(last-working-dir pip)

if [ -d $ZSH ]; then
	source $ZSH/oh-my-zsh.sh
fi

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:
	/usr/games:/usr/local/games:/home/sevko/.local/bin:/usr/local/sbin:
	/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
