#! /usr/bin/zsh

#   Description:
#       Script to install .dotfiles/ on a new machine, by creating necessary
#       symlinks between files inside and outside the archive.
#
#   Use:
#       ./install.zsh

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

# files/directories whose corresponding file may exist in a sub-dir of
# $HOME/.dotfiles/ or have a different name
typeset -A special_files
special_files=(
	"$HOME/.ssh/config" "sshconfig"
	"$HOME/.gconf/apps/gnome-terminal" "gnome_terminal"
	"$HOME/.vim/after/ftplugin" "vim/ftplugin"
)

link_files(){
	(ln -s $1 $2 &> /dev/null && print "ln -s $1 $2.") || \
		print "Error: \`ln -s $1 $2\` failed!"
}

# create symlinks for all regular files
for file in $files; do
	if [[ -e $file || -L $file || -d $file ]]; then
		rm -rf $file
	else
		mkdir -p ${file%/*}
	fi

	link_files $HOME/.dotfiles/${${file##*/}#.*} $file
done

# create symlinks for all special files
for file in ${(k)special_files}; do
	if [[ -e $file || -L $file || -d $file ]]; then
		rm $file
	else
		mkdir -p ${file%/*}
	fi

	link_files $HOME/.dotfiles/$special_files[$file] $file
done
