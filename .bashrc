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
   PS1='${debian_chroot:+($debian_chroot)}\[\033[1;36m\]§ \[\033[1;32m\]\h\[\033[0;36m\] {\[\033[1;36m\]\w\[\033[0;36m\]}\[\033[39m\] '
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

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

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
export TOOLS="$HOME/tools"
export JAVA_HOME="$TOOLS/jdk1.6.0_11"
export PATH=$TOOLS/jdk1.6.0_11/bin:$TOOLS/maven/bin:$TOOLS/nant-0.85/bin:$PATH
export RUBYOPT=rubygems
export GEM_HOME=$TOOLS/gems_repo

alias grep='grep --color'
export EDITOR=vim

#
# run fortune at startup
#
fortune
