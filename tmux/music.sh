#! /bin/bash

# Description:
#   Prints CMUS information about the currently playing track for use in my
#   tmux statusline..
#
# Use:
#   ./music.sh

cmus_info=""

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

fmt_seconds(){
	# Output seconds formatted as minutes/seconds.
	#
	# Args:
	#   $1 (int): The seconds to convert.
	#
	# Return:
	#   (str) `$1` formatted as `mm:ss`, or minutes and seconds.

	echo "$(expr $1 / 60):$(printf "%02d" $(expr $1 % 60))"
}

parse_cmus(){
	# Parse `$cmus_info`.
	#
	# Args:
	#   $1 (str): A Perl regular expression for `grep`.
	#
	# Return
	#   Any string in `$cmus_info` that matches `$1`.

	echo "$cmus_info" | grep -oP "$1"
}

cmus_info(){
	# Construct the music statusline segment.
	#
	# Return:
	#   (str) A formatted `tmux` statusline snippet containing the currently
	#   playing song's time, total length, audio level artist name, and title.

	cmus_info="$(cmus-remote -Q 2>&1)"
	if [[ $? == 0 ]]; then
		local status=$(parse_cmus "(?<=status ).*")

		# Check whether a song is currently loaded (whether it's playing or
		# paused).
		if [ ! "$status" = "stopped" ]; then
			local artist=$(parse_cmus "(?<=tag artist ).*$")
			local song=$(parse_cmus "(?<=tag title ).*$")

			# Check whether the current track has id3 tags.
			local music;
			if [[ $song ]] || [[ $artist ]]; then
				music="#[bold]${artist%% }#[nobold] - $song"
			else
				local song=$(basename "$(parse_cmus "(?<=file ).*")")
				music="${song%%.*}"
			fi

			case $status in
				"paused") local symbol=" ■";;
				"playing") local symbol=" ▶";;
			esac

			local curr_time=$(fmt_seconds "$(parse_cmus "(?<=^position ).*")")
			local total_time=$(fmt_seconds "$(parse_cmus "(?<=^duration ).*")")
		else
			local symbol=""
			local curr_time="00:00"
			local total_time="00:00"
			local music="none"
		fi

		# Print formatted tmux statusline-segment (with color/text specifiers).
		local output="#[fg=colour232,bg=colour2]$symbol"
		output="$output #[bold]$curr_time#[nobold]/$total_time"
		echo "$output $(get_audio_level) #[italics]$music#[noitalics] "
	fi
}

main(){
	echo "$(cmus_info)"
}

main
