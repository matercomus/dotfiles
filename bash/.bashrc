#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
# PS1='[\u@\h \W]\$ '

# Default Apps
export EDITOR="lvim"
export READER="llpp"
export VISUAL="lvim"
export TERMINAL="alacritty"
export BROWSER="firefox"
export VIDEO="mpv"
export IMAGE="nsxiv"
export COLORTERM="truecolor"
export OPENER="xdg-open"
export PAGER="less"
export TERM='xterm-256color'
# Path
export PATH=/usr/local/bin:/usr/sbin:/bin:/usr/bin:$HOME/bin:$HOME/.scripts:$HOME/opt:$HOME/go/bin:$HOME/.local/bin:$path[@]

