#!/bin/sh

## Bash IFs Explained:
## - https://unix.stackexchange.com/questions/306111/what-is-the-difference-between-the-bash-operators-vs-vs-vs
## - if flags: http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html

## =~ Explained:
## - https://unix.stackexchange.com/questions/340440/bash-test-what-does-do
## - Regrex examples: https://cs.lmu.edu/~ray/notes/regex/

## select-pane -P sets the style for a single pane.
## - http://man7.org/linux/man-pages/man1/tmux.1.html

## Color Wheel
## https://www.canva.com/colors/color-wheel/

## background color
readonly bg_1="#a23351"
## prompt color
readonly pt_1="#3F9CA8"
## highlight color background
readonly hg_1="#FF5000"
## Set tmux bg/fg color referece:
## - https://stackoverflow.com/questions/25532773/change-background-color-of-active-or-inactive-pane-in-tmux/33553372#33553372


readonly bg_2="#4a6ab5"
readonly pt_2="#D5612A"
readonly hg_2="#7153AC"


readonly bg_3="#9C637A"
readonly pt_3="#3EC1BD"
readonly hg_3="#58A7A0"


if [[ "$TERM" = "screen"* ]] && [[ -n "$TMUX" ]]; then
  if [ "$1" == "1" ]; then
    tmux select-pane -P bg=$bg_1,fg=$pt_1
  elif [ "$1" == "2" ]; then
    tmux select-pane -P bg=$bg_2,fg=$pt_2
  else
    tmux select-pane -P bg=$bg_3,fg=$pt_3
  fi;

else
  ## e.g. TERM=xterm-256color
  if [ "$1" == "1" ]; then
    printf '\033]11;%s\007' "$bg_1"
    printf "\033]10;%s\007" "$pt_1"
    printf "\033]17;%s\007" "$hg_1"

  elif [ "$1" == "2" ]; then
    printf '\033]11;%s\007' "$bg_2"
    printf "\033]10;%s\007" "$pt_2"
    printf "\033]17;%s\007" "$hg_2"

  else
    printf '\033]11;%s\007' "$bg_3"
    printf "\033]10;%s\007" "$pt_3"
    printf "\033]17;%s\007" "$hg_3"
  fi

fi

## References:
##
## Script adapted from:
## - http://bryangilbert.com/post/etc/term/dynamic-ssh-terminal-background-colors/
##
## ANSI Escape sequences:
## - http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/c327.html
## - https://askubuntu.com/questions/831971/what-type-of-sequences-are-escape-sequences-starting-with-033
## - https://godoc.org/github.com/Xuyuanp/glogger/formatters
## - https://stackoverflow.com/questions/41485511/meanings-of-terminal-codes-033e-and-03307-which-appear-in-printf-statemen
##
##
## To set promt as blue and background as cyan
## - http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
## - http://ascii-table.com/ansi-escape-sequences.php
## printf '\033[34;46m'
##
##
##
## F11 key == \033[11 (Telnet)
## - https://jscape.kayako.com/Knowledgebase/Article/View/5/0/sending-ctrla-ctrlh-f1-f12-and-other-function-keys-to-telnet-server
##
##
## XTerm Control Sequences:
##
##
## BEL Char '\007' or '\a'
## - http://tldp.org/HOWTO/Xterm-Title-4.html
## - https://en.wikipedia.org/wiki/Bell_character
##
##
## \033] or ESC ] == Operating System Command (OSC)
## - https://lwn.net/Articles/665053/
## - https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h2-Operating-System-Commands
##
##
## Explained:
## \033]  11  ; #33831F  \007
## OSC    Ps  ; Pt       BEL
##
## Ps - A single (usually optional) numeric parameter, composed of one or more digits.
## Pt - A text parameter composed of printable characters.
## Ps = 11 -> Change VT100 text background color to Pt.
##
## - https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h2-VT100-Mode
## - https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h2-Definitions
##
##
## Set title of Terminal Window
## - https://unix.stackexchange.com/questions/208436/bell-and-escape-character-in-prompt-string
##
## Ps = 0 -> Change Icon Name and Window Title to Pt.
##
## PROMPT_COMMAND= ; printf '\033]0;Hello World!\007'
## PROMPT_COMMAND= ; printf '\033]0;%s@%s:%s\007' user host /home/user
