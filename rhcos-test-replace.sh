#!/bin/bash
echo "admin unlock"
sudo ostree admin unlock --hotfix

echo "override replace"
sudo rpm-ostree override replace *.rpm

sudo rpm-ostree status -v

echo "reboot"
sudo reboot
