# dictionary of special font escape codes
typeset -Ag font
font=(
	reset "%{[00m%}"
	bold "%{[01m%}"
	no-bold "%{[22m%}"
	italic "%{[03m%}"
	no-italic "%{[23m%}"
	underline "%{[04m%}"
	no-underline "%{[24m%}"
	blink "%{[05m%}"
	no-blink "%{[25m%}"
	reverse "%{[07m%}"
	no-reverse "%{[27m%}"
)

fg(){
	# Return foreground color escape code, where color value is the first
	# argument.

	echo "%{[38;5;$1m%}"
}

bg(){
	# Return background color escape code, where color value is the first
	# argument.

	echo "%{[48;5;$1m%}"
}

inside_git_archive(){
	# Indicate whether current directory is inside a git archive.

	[ -d .git ] || git rev-parse --is-inside-work-tree > /dev/null 2>&1
}

git_branch_status(){
	# If inside git archive, return current branch name and indicate whether
	# dirty.

	if $(inside_git_archive)
	then
		branchName=$(git symbolic-ref --short HEAD 2> /dev/null \
			|| git rev-parse HEAD | cut -b-10) # branch name
		git diff --quiet --ignore-submodules HEAD &>/dev/null	# whether dirty
		branchStatus=$([ "$?" = 1 ] && echo "$(fg 196)± ")
		echo "$(fg 40) $branchStatus$(fg 73)$branchName$font[reset]"
	fi
}

dir_path(){
	# Return formatted working directory path.

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

user_info(){
	# Indicate username and hostname if not the same as those of my standard
	# account.

	if [ "$USERNAME" != "sevko" ] || [ "$HOST" != "saturn" ]; then
		echo "$(fg 2)$USERNAME$font[reset]$(fg 14)/$HOST "
	fi
}

function zle-line-init zle-keymap-select {
	VIM_PROMPT="$(fg 1)[% NORMAL]% %{$reset_color%}"
	RPS1_BODY='$(git_branch_status)$exit_status$font[reset]'
	RPS1="${${KEYMAP/vicmd/$VIM_PROMPT }/(main|viins)/}$RPS1_BODY"
	zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

prompt_head="$(fg 202) λ $font[reset]"
exit_status="%(?..$(fg 160)$font[bold] ✘ %?)"

setopt PROMPT_SUBST
PROMPT='$(user_info)$(dir_path)$prompt_head'

PS2="  $font[bold]$(fg 1)%_$(fg 1)$font[reset] $(fg 2)→$font[reset]"
