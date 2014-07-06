#! /bin/bash

# Description:
#   Prints the network name and signal strength to `stdout`.

has_internet_connection(){
	# Check whether the computer is connected to the internet.

	local test_ip1="8.8.8.8"
	local test_ip2="4.2.2.1"
	(ping -w5 -c1 "$test_ip1" || ping -w5 -c1 "$test_ip2") > /dev/null
	return $?
}

print_network_info(){
	# Prints the name of the current network and the signal strength as gauged
	# by `iwconfig`. If the computer isn't connected to a network, simply
	# prints "N/A".

	if has_internet_connection; then
		local network_data=$(iwconfig wlan0)
		local network_name=$(\
			echo $network_data |\
			grep -oP "(?<=ESSID:\").*(?=\")")
		local signal_strength=$(\
			echo $network_data |\
			grep -oP "(?<=Link Quality=)[^ ]+")
		echo "$network_name $signal_strength"
	else
		echo "N/A"
	fi
}

print_network_info
