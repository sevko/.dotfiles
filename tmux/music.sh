#! /bin/bash

# Description:
#   Prints CMUS information about the currently playing track for use in my
#   tmux statusline..
#
# Use:
#   ./music.sh

get_audio_level(){
	# Output the current audio level.
	#
	# Return:
	#   (str) My audio level as a percentage, in the format "([0-100]%)".

	local audio_percentage="$(
		amixer sget Master | grep -oP "(?<=\[)[0-9]*(?=%])"
	)"

	echo "($audio_percentage%)"
}

format_seconds(){
	# Output seconds formatted as minutes/seconds.
	#
	# Args:
	#   $1 (int): The seconds to convert.
	#
	# Return:
	#   (str) `$1` formatted as `mm:ss`, or minutes and seconds.

	echo "$(expr $1 / 60):$(printf "%02d" $(expr $1 % 60))"
}

cmus_info(){
	# Construct the music statusline segment.
	#
	# Return:
	#   (str) A formatted `tmux` statusline snippet containing the currently
	#   playing song's time, total length, audio level artist name, and title.

	local cmus_info;
	cmus_info="$(cmus-remote -Q 2>&1)"

	if [[ $? == 0 ]]; then
		local status="$(echo "$cmus_info" | grep -oP "(?<=status ).*")"

		if [ ! "$status" = "stopped" ]; then
			local artist=$(echo "$cmus_info" | grep -oP "(?<=tag artist ).*$")
			local artist=${artist%% }
			local song=$(echo "$cmus_info" | grep -oP "(?<=tag title ).*$")
			case $status in
				"paused") local symbol="■";;
				"playing") local symbol="▶";;
			esac

			local curr_time=$(
				format_seconds "$(
					echo "$cmus_info" | grep -oP "(?<=^position ).*"
				)"
			)
			local total_time=$(
				format_seconds "$(
					echo "$cmus_info" | grep -oP "(?<=^duration ).*"
				)"
			)
			local music="$artist - $song"
		else
			local symbol="×"
			local curr_time="00:00"
			local total_time="00:00"
			local music="none"
		fi

		local output="#[fg=colour232,bg=colour2] $symbol"
		output="$output #[bold]$curr_time#[nobold]/$total_time"
		echo "$output $(get_audio_level) #[italics]$music#[noitalics] "
	fi
}

main(){
	echo "$(cmus_info)"
}

main
