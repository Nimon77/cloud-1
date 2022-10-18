#!/bin/zsh

if [ $# -eq 0 ]
  then
	echo "No arguments supplied"
	echo "Usage: ./first.sh <Nb hosts>"
	exit 1
fi

if [[ -z "$ANSIBLE_CONFIG" ]]; then
	echo "ANSIBLE_CONFIG is not set"
	echo "use: export ANSIBLE_CONFIG=$PWD/config.cfg"
fi

IP=$(ip a s en0 | grep "inet " | cut -d " " -f 2 | cut -d "/" -f 1)

getSSHKey() {
	{ echo -ne "HTTP/1.0 200 OK\r\nContent-Length: $(wc -c < authorized_keys)\r\n\r\n"; cat authorized_keys; } | nc -l -p 8080 &
	multipass exec $1 -- curl -s http://$IP:8080 -o /home/ubuntu/.ssh/authorized_keys
}

multipass delete --all
multipass purge
for i in {1..$1}
do
	multipass launch -n host-$i --bridged 20.04
	getSSHKey host-$i
done