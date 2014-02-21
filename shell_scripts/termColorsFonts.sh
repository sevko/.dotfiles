# dictionary of special font escape codes
typeset -Ag font
font=(
	reset       "%{[00m%}"
	bold        "%{[01m%}" no-bold        "%{[22m%}"
	italic      "%{[03m%}" no-italic      "%{[23m%}"
	underline   "%{[04m%}" no-underline   "%{[24m%}"
	blink       "%{[05m%}" no-blink       "%{[25m%}"
	reverse     "%{[07m%}" no-reverse     "%{[27m%}"
)

# return foreground color escape code, where color value is the first argument
fg(){
	echo "%{[38;5;$1m%}"
}

# return background color escape code, where color value is the first argument
bg(){
	echo "%{[48;5;$1m%}"
}
