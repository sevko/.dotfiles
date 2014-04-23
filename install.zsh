#! /usr/bin/zsh

# Description:
#     Script to install .dotfiles/ on a new machine, by creating necessary
#     symlinks between files inside and outside the archive.
#
# Use:
#     ./install.zsh

# files whose corresponding file is located in $HOME/.dotfiles/ without the
# leading period, if any
regular_files=(
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
	"$HOME/.vim/autoload/pathog.vim" "vim/bundle/pathogen/autoload/pathogen.vim"
)

# Create a symbolic link to a file, with status reporting.
#
# Args:
#   $1 - The path of the file to create a symbolic link to.
#   $2 - The path (name) of the symbolic link.
create_symbolic_link(){
	(ln -s $1 $2 &> /dev/null && print "ln -s $1 $2.") || \
		print "Error: \`ln -s $1 $2\` failed!"
}

# Create symbolic links for all regular files.
#
# Create links between all files in $regular_files and their counterparts in
# `~/.dotfiles`.
create_regular_links(){
	for file in $regular_files; do
		if [[ -e $file || -L $file || -d $file ]]; then
			rm -rf $file
		else
			mkdir -p ${file%/*}
		fi

		create_symbolic_link $HOME/.dotfiles/${${file##*/}#.*} $file
	done
}

# Create symbolic links for all special_files files.
#
# Create links between all files in $special_files and their counterparts in
# `~/.dotfiles`.
create_special_links(){
	for file in ${(k)special_files}; do
		if [[ -e $file || -L $file || -d $file ]]; then
			rm $file
		else
			mkdir -p ${file%/*}
		fi

		create_symbolic_link $HOME/.dotfiles/$special_files[$file] $file
	done
}

# Conduct all .dotfiles/ setup.
setup(){
	git submodule init && git submodule update
	create_regular_links
	create_special_links
}

setup
