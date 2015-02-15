#! /bin/bash

# Description:
#   Prints the current network name.

has_internet_connection(){
	# Checks whether the computer is connected to the internet.

	local test_ip1="google.com"
	local test_ip2="yahoo.com"
	(ping -w5 -c1 "$test_ip1" || ping -w5 -c1 "$test_ip2") > /dev/null
	return $?
}

print_network_info(){
	# If the computer is connected to the internet, print the network name;
	# otherwise, "N/A".

	if has_internet_connection; then
		local network_data=$(iwconfig wlan0)
		local network_name=$(\
			echo $network_data |\
			grep -oP "(?<=ESSID:\").*(?=\")")
		echo "$network_name"
	else
		echo "none"
	fi
}

print_network_info
