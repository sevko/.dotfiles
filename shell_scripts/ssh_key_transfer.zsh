#! /usr/bin/zsh

#   Description:
#       Script to automate ssh public-key addition to a new remote machine.
#
#   Use:
#       ./ssh_key_transfer.zsh HOSTNAME
#
#       HOSTNAME -- hostname of the remote machine

# exit if no argument given
if [ "$1" = "" ]; then
	echo "Hostname required."
	exit 1
fi

stty -echo
echo "Password: "
read password
stty echo

#scp key over, append it to ~/.ssh/authorized_keys
sshpass -p $password scp ~/.ssh/id_rsa.pub $1:~/id_rsa_sevko.pub > /dev/null
sshpass -p $password ssh -q $1 << COMMANDS > /dev/null
	mkdir -p .ssh
	cat id_rsa_sevko.pub >> .ssh/authorized_keys
	rm id_rsa_sevko.pub
COMMANDS
