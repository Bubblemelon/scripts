#!/bin/bash
echo "wpa -- cancel systemd stuff"
echo "revert -- have the system as was before"

case $1
	"wpa")
		sudo systemctl stop NetworkManager
		sudo systemctl stop systemd-networkd
	 "revert)
		sudo systemctl start NetworkManager
		sudo systemctl enable system-networkd
	)
		exit
esac


