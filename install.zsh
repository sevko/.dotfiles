#! /bin/zsh

# files whose corresponding file is located in $HOME/.dotfiles/ without the
# leading period, if any
files=(
	"$HOME/.bashrc"
	"$HOME/.gitconfig"
	"$HOME/.tmux.conf"
	"$HOME/.vimrc"
	"$HOME/.zshrc"
	"$HOME/.vimrc_after"
)

# files whose corresponding file may exist in a sub-dir of $HOME/.dotfiles/ or
# have a different name
typeset -A special_files
special_files=(
	"$HOME/.ssh/config" "ssh/config"
)

# all directories to be linked
typeset -A directories
directories=(
	"$HOME/.gconf/apps/gnome-terminal" "gnome_terminal"
	"$HOME/.vim/after/ftplugin" "vim/ftplugin"
)

link_files(){
	(ln -s $1 $2 &> /dev/null && print "ln -s $1 $2.") || \
		print "Error: \`ln -s $1 $2\` failed!"
}

# create symlinks for all regular files
for file in $files; do
	if [[ -e $file || -L $file ]]; then
		rm $file
	fi
	link_files $HOME/.dotfiles/${${file##*/}#.*} $file
done

echo "\n---\n"

# create symlinks for all special files
for file in ${(k)special_files}; do
	if [[ ! -e $file ]]; then
		mkdir -p ${file%/*}
	else
		rm $file
	fi

	link_files $HOME/.dotfiles/$special_files[$file] $file
done

echo "\n---\n"

# create symlinks for all directories
for dir in ${(k)directories}; do
	rootPath=${dir%/*}
	if [[ ! -d $dir ]]; then
		mkdir -p $rootPath
	else
		rm -rf $dir
	fi

	link_files $HOME/.dotfiles/$directories[$dir] $dir
done
