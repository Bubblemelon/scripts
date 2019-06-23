# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# $ history
# X : max of X number of commands saved
# = 0 : None saved
# < 0 : infinite history list
HISTSIZE==-1

# .bash_history
# X : max of X number of lines (removes older lines to maintain max)
# 0 : file truncated (shorten) to size 0
# < 0 or non-numeric : inhibits truncation
HISTFILESIZE=-1

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
export PATH=$PATH:$HOME/.local/bin:/usr/bin/:~/Desktop/Github/container-linux-config-transpiler/bin:~/Desktop/Github/tectonic-installer/tectonic-dev/installer:$JAVA_HOME/bin:$(go env GOPATH)/bin:~/bin

## GO ENV
export GOPATH=$HOME/go
export PATH2CT=~/Desktop/Github/container-linux-config-transpiler/bin
export GOGITHUB=~/go/src/github.com

# Command Aliases:
alias github='cd ~/github'
alias gerrit='cd ~/gerrit'
alias go-github='cd ~/go/src/github.com'
alias sdk='cd ~/coreos-sdk'
alias ign='cd ${GOPATH}/src/github.com/coreos/ignition'
alias crk='cd ~/coreos-sdk; cork enter'
alias sdk-ign='cd /home/cherylfong/coreos-sdk/src/third_party/ignition'
alias bubblemelon='cd ~/go/src/github.com/bubblemelon'
alias spitjson='python -m json.tool'
alias la='ls -a'
alias lla='ls -la'
alias adbfoward='/home/cherylfong/Android/Sdk/platform-tools/adb forward tcp:8080 tcp:8080 && google-chrome http://localhost:8080'
# alias ssh=color-ssh
alias aws-bubblemelon='ssh -X ubuntu@54.68.68.106 -i ~/.ssh/bubblemelonServer.pem'
alias aws-868='ssh -X ubuntu@13.52.51.45 -i ~/.ssh/868-server.pem'

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

# JAVA ENV
#
# Guide: https://access.redhat.com/documentation/en-US/JBoss_Communications_Platform/5.0/html/Platform_Installation_Guide/sect-Configuring_Java.html
#
# java home export path should not include /bin/java !
#
# openjdk version
# export JAVA_HOME=/usr/lib/jvm/java-10-openjdk-10.0.2.13-1.fc28.x86_64/
# jdk standard edittion
# https://docs.oracle.com/cd/E19182-01/820-7851/inst_cli_jdk_javahome_t/
# http://www.oracle.com/technetwork/java/javase/downloads/index.html
export JAVA_HOME=/usr/java/jdk-10.0.2/

# Saves command history from different sessions
# https://askubuntu.com/questions/339546/how-do-i-see-the-history-of-the-commands-i-have-run-in-tmux
#
# Avoid duplicates
export HISTCONTROL=ignoredups:erasedups
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend
#
# After each command, append to the history file and reread it
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
#
# export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

color-ssh() {
    trap ".color-term.sh" INT EXIT
	# if $* contains the substring "bubble"
    if [[ "$*" =~ "bubble" ]]; then
        ./.color-term.sh 1
    elif [[ "$*" =~ "ubuntu" ]]; then
        ./.color-term.sh 2
    else
        ./.color-term.sh
    fi
	# ssh $*
}
# set `ssh` to call color-ssh() via:
# alias ssh=color-ssh
# https://unix.stackexchange.com/questions/57940/trap-int-term-exit-really-necessary
# reference: http://bryangilbert.com/post/etc/term/dynamic-ssh-terminal-background-colors/
