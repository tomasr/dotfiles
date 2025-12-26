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


# Color definitions
BGBLACK=$(printf '\001\e[40m\002')
BGWHITE=$(printf '\001\e[107m\002')
BGDGREEN=$(printf '\001\e[42m\002')
BGGREEN=$(printf '\001\e[102m\002')
BGLCYAN=$(printf '\001\e[106m\002')
BGTEAL=$(printf '\001\e[46m\002')
BGDARKBLUE=$(printf '\001\e[44m\002')
BGMAGENTA=$(printf '\001\e[45m\002')

FGBLACK=$(printf '\001\e[30m\002')
FGWHITE=$(printf '\001\e[97m\002')
FGDGREEN=$(printf '\001\e[32m\002')
FGGREEN=$(printf '\001\e[92m\002')
FGLCYAN=$(printf '\001\e[96m\002')
FGTEAL=$(printf '\001\e[36m\002')
FGDARKBLUE=$(printf '\001\e[34m\002')
FGMAGENTA=$(printf '\001\e[35m\002')

CRESET=$(printf '\001\e[0m\002')

function prompt_lead() {
  echo -n "$BGMAGENTA$FGWHITE"
}

function prompt_sep1() {
  echo -n "$BGBLACK$FGMAGENTA$FGBLACK$BGDARKBLUE$BGDARKBLUE$FGWHITE"
}

function prompt_sep2() {
  echo -n "$BGBLACK$FGDARKBLUE$FGBLACK$BGTEAL$BGTEAL$FGWHITE"
}

function prompt_sep3() {
  echo -n "$BGBLACK$FGTEAL$CRESET"
}

function prompt_2ndline() {
  echo -n "$BGWHITE$FGBLACK § $BGBLACK$FGWHITE $CRESET"
}

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
#

PS1='$(prompt_lead) ℞ \h $(prompt_sep1) \D{%F} \t $(prompt_sep2) ✓ \w $(prompt_sep3)\n$(prompt_2ndline)'
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
export EDITOR=nvim
