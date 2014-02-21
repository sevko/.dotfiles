source ~/.dotfiles/shell_scripts/termColorsFonts.zsh

# indicate whether current directory is inside a git archive
inside_git_archive(){
	[ -d .git ] || git rev-parse --is-inside-work-tree > /dev/null 2>&1
}

# if inside git archive, return current branch name and indicate whether dirty
git_branch_status(){
	if $(inside_git_archive)
	then
		branchName=$(git symbolic-ref --short HEAD)             # branch name
		git diff --quiet --ignore-submodules HEAD &>/dev/null   # whether dirty
		branchStatus=$([ "$?" = 1 ] && echo "$(fg 196)± ")
		echo "$(fg 40) $branchStatus$(fg 73)$branchName$font[reset]"
	fi
}

# return formatted working directory path
dir_path(){

	# replace $HOME in $PWD with "~" character
	if [[ "$PWD" =~ ^"$HOME"(/|$) ]]; then
		workingDir="$(fg 38)~${PWD#$HOME}"
	else
		workingDir="$(fg 38)$PWD"
	fi

	# if current directory is part of a git archive, highlight any directories
	# that are part of the archive in a color different from the path
	if $(inside_git_archive); then
		gitRootDir=${$(git rev-parse --show-toplevel)##*/}
		gitRootPre=${workingDir%$gitRootDir*}
		gitRootPost=${gitRootDir##*/}${workingDir#*$gitRootDir}

		workingDir="$gitRootPre$(fg 43)$font[bold]$gitRootPost$font[reset]"
	fi

	[[ ! -w $PWD ]] && workingDir="$workingDir$(fg 196) "
	echo -n $workingDir
}

ssh_info(){
	if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
		echo "$font[bold]$(fg 43)$USERNAME$font[reset]$(fg 202)@$HOST "
	fi
}

prompt_head="$(fg 202) λ $font[reset]"
exit_status=" %(?..$(fg 160)$font[bold]✘ %?)"

setopt PROMPT_SUBST
PROMPT='$(ssh_info)$(dir_path)$prompt_head'
RPROMPT='$(git_branch_status)$exit_status$font[reset]'
