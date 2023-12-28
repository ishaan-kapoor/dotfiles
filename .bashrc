#!/bin/bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

PS1=' \w > '
# set -o vi
HISTSIZE=-1  # unlimited history
HISTFILESIZE=-1  # unlimited history
HISTCONTROL="ignoredups:ignorespace:erasedups"  # ignores repeated duplicate commands and the ones that have space before them
HISTIGNORE="exit:clear"

shopt -s histappend # append to the history file, don't overwrite it
shopt -s checkwinsize  # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s globstar # If set, the pattern "**" used in a pathname expansion context will match all files and zero or more directories and subdirectories.
shopt -s autocd # If set, a command name that is the name of a directory is executed as if it were the argument to the cd command.
shopt -s cdspell                  # attempt spelling correction of cd arguments
shopt -s checkwinsize             # allow window resizing
shopt -s cmdhist                  # save multi-line commands as one command in history
shopt -s direxpand                # expand directories
shopt -s dirspell                 # attempt spelling correction of dirname
shopt -u no_empty_cmd_completion  # enable empty command completion


[ -f ~/.config/shellrc ] && source ~/.config/shellrc
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# [ -d "$HOME/.local/share/nvim/mason/bin/" ] && export PATH="$HOME/.local/share/nvim/mason/bin/:$PATH"

export LS_COLORS="$LS_COLORS:ow=30;44:"
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01' # colored GCC warnings and errors

# enable programmable completion features (you don't need to enable this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -f /etc/bash.command-not-found ]; then
    . /etc/bash.command-not-found
    # sudo wget -O /etc/bash.command-not-found https://raw.githubusercontent.com/hkbakke/bash-insulter/master/src/bash.command-not-found
fi
