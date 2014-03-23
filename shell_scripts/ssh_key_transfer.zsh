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

# scp key over, append it to ~/.ssh/authorized_keys
scp ~/.ssh/id_rsa.pub $1:~/id_rsa_sevko.pub
ssh $1 << COMMANDS
	[ -d .ssh ] || mkdir .ssh
	cat id_rsa_sevko.pub >> .ssh/authorized_keys
	rm id_rsa_sevko.pub
COMMANDS > /dev/null
