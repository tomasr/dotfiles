# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Comment in the above and uncomment this below for a color prompt
case "$TERM" in
xterm*|rxvt*|screen*|cygwin*)
#   PS1='${debian_chroot:+($debian_chroot)}\[\033[32m\]\u@\h\[\033[00m\] {\[\033[36m\]\w\[\033[00m\]} '
# https://misc.flogisoft.com/bash/tip_colors_and_formatting
# first block:
#   blue background: \e[44m
#   white foreground: \e[97m
# second block:
#   green background: \e[42m
#   white foreground: \e[97m
# third block:
#   cyan background: \e[106m
#   black foreground: \e[32m

    BGDARKBLUE=$(printf '\e[44m')
    FGDARKBLUE=$(printf '\e[34m')
    BGWHITE=$(printf '\e[107m')
    FGWHITE=$(printf '\e[97m')
    FGGREEN=$(printf '\e[92m')
    BGGREEN=$(printf '\e[102m')
    FGDGREEN=$(printf '\e[32m')
    BGDGREEN=$(printf '\e[42m')
    BGBLACK=$(printf '\e[40m')
    FGBLACK=$(printf '\e[30m')
    BGLCYAN=$(printf '\e[106m')
    FGLCYAN=$(printf '\e[96m')
    BGTEAL=$(printf '\e[46m')
    FGTEAL=$(printf '\e[36m')
    BGMAGENTA=$(printf '\e[45m')
    FGMAGENTA=$(printf '\e[35m')
    CRESET=$(printf '\e[0m')

    PS1='${BGMAGENTA}${FGWHITE} \h ${BGDARKBLUE}${FGMAGENTA}${BGDARKBLUE}${FGWHITE} \t ${BGTEAL}${FGDARKBLUE}${BGTEAL}${FGWHITE} \w ${BGBLACK}${FGTEAL}${CRESET}\n${BGWHITE}${FGBLACK} § ${BGBLACK}${FGWHITE} ${CRESET}'
    ;;
*)
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    ;;
esac
# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

alias cls=clear
alias grep='grep --color'
export EDITOR=vim
