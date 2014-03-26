#! /bin/zsh

# files whose corresponding file is located in ~/.dotfiles/ without the leading
# period, if any
files=("~/.bashrc" "~/.gitconfig" "~/.tmux.conf" "~/.vimrc" "~/.zshrc"
	"~/.vimrc_after")

# files whose corresponding file may exist in a sub-dir of ~/.dotfiles/ or have
# a different name
typeset -A special_files
special_files=(
	"~/.ssh/config" "ssh/config"
)

# all directories to be linked
typeset -A directories
directories=(
	"~/.gnome-terminal" "gnome_terminal"
	"~/.vim/after/ftplugin" "vim/ftplugin"
)

# create symlinks for all regular files
for file in $files; do
	if [[ -e $file ]]; then
		rm $file
	fi
	ln -s ~/.dotfiles/${${file##*/}#.*} $file
done

# create symlinks for all special files
for file in ${(k)special_files}; do
	if [[ ! -e $file ]]; then
		mkdir -p ${file%/*}
	else
		rm $file
	fi

	ln -s ~/.dotfiles/$special_files[$file] $file
done

# create symlinks for all directories
for dir in ${(k)directories}; do
	rootPath=${file%/*}
	if [[ ! -d $dir ]]; then
		echo "mkdir -p $rootPath"
	else
		rm -rf $dir
	fi
	ln -s ~/.dotfiles/$directories[$dir] $dir
done
