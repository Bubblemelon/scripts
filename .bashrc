# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
export PATH=$PATH:$HOME/.local/bin:/usr/bin/:~/Desktop/Github/container-linux-config-transpiler/bin:~/Desktop/Github/tectonic-installer/tectonic-dev/installer
export GOPATH=$HOME/go
export PATH2CT=~/Desktop/Github/container-linux-config-transpiler/bin

# Command Aliases:
alias github='cd ~/Desktop/Github'
alias go-github='cd ~/go/src/github.com'
alias sdk='cd ~/coreos-sdk'
alias ign='cd ${GOPATH}/src/github.com/coreos/ignition'
alias crk='cd ~/coreos-sdk; cork enter'
alias sdk-ign='cd /home/cherylfong/coreos-sdk/src/third_party/ignition'
alias bubblemelon='cd ~/go/src/github.com/bubblemelon'
alias spitjson='python -m json.tool'
alias la='ls -a'
alias lla='ls -la'

ipack() {
ign
./build ignition
cd bin
scp -i ~/.ssh/packet_rsa -r amd64/ core@147.75.68.163:~
}

### ~ Executes whenever a New Terminal Launches ~ ###
#for i in {1..8}
#do
#	echo "*"
#done	

#date +%X
###

################ records bash output ######################
record() {
	bash ~/.bash_output_history/bash_output_history.sh
}

isrecord() {
	if pgrep -x "script" > /dev/null
	then
		echo "Running"
	else
		echo "Stopped"
	fi	
}

recloc() {
	cd ~/.bash_output_history/
}
###########################################################

# ssh-agent daemon 
# 
# service file location: /etc/systemd/user/ssh-agent.service 
# 
# systemctl --user enable ssh-agent
# systemctl --user start ssh-agent
# 
# https://stackoverflow.com/questions/18880024/start-ssh-agent-on-login
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket" 

# Docker
export DOCKER_ID_USER="bubblemelon"

# Tectonic + Openshift
# export PATH=/home/cherylfong/Desktop/Github/tectonic-installer/tectonic-dev/installer:$PATH
export CLUSTER_NAME=coreos-220
export BASE_DOMAIN=tt.testing
