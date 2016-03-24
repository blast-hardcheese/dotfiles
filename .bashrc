# ~/.bashrc: executed by bash(1) for non-login shells.

if [ -f ~/.pathrc ]; then
    source ~/.pathrc
fi

if [ -d ~/.tools/ ]; then
  export PYTHONPATH=$PYTHONPATH:~/.tools/:~/.tools/code/python/
fi

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

if [ -f ~/.auth_sockrc ]; then
    source ~/.auth_sockrc
fi


# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Timestamps in `history' output
export HISTTIMEFORMAT="%s "

unset HISTFILESIZE
export HISTFILESIZE

unset HISTSIZE
export HISTSIZE

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm*|rxvt*)
      color_prompt=yes
      # If this is an xterm set the title to user@host:dir
      PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
    screen) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# Alias definitions.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Function definitions.

if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
HASCOMPLETION=0
if ! shopt -oq posix; then
    if [ -f ~/.tools/localized/bash-completion/bash_completion ]; then
        source ~/.tools/localized/bash-completion/bash_completion

        HASCOMPLETION=1
    elif [ -f /etc/bash_completion ]; then
        source /etc/bash_completion

        HASCOMPLETION=1
    elif [ -f /opt/local/etc/bash_completion ]; then
        # MacPorts Bash shell command completion
        source /opt/local/etc/bash_completion

        HASCOMPLETION=1
    elif type brew >/dev/null 2>&1 && [[ -f `brew --prefix`/etc/bash_completion ]]; then
        # Homebrew Bash shell command completion
        source `brew --prefix`/etc/bash_completion

        HASCOMPLETION=1
    fi

    if [ $HASCOMPLETION == 1 -a -d ~/.bash_completions ]; then
        for COMP in ~/.bash_completions/*.completion; do
            source "$COMP"
        done
    fi
    unset HASCOMPLETION
fi

# Git PS1 support
if [[ $(__git_ps1 1>/dev/null 2>/dev/null) || $? == 0 ]]; then
  GITPS1='$(__git_ps1 " \[\033[31m\](%s)\[\033[0m\]")'
else
  GITPS1=''
fi
PS1="\[\033[0m\]\h:\W$GITPS1 \u\$ \[\033[0m\]"

PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\h: \w\a\]$PS1"

export LESS='-RFMSXix4'
if [ -f /usr/share/source-highlight/src-hilite-lesspipe.sh ]; then
  export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
fi

HISTNAME=$(hostname -s).hist
if [ -f ~/.bash_history ]; then
  TEMPNAME=$HISTNAME-$(date +%s)
  if [ ! -e $TEMPNAME ]; then
    mv ~/.bash_history ~/$TEMPNAME
    mkdir ~/.bash_history
    mv -i $TEMPNAME ~/.bash_history/$HISTNAME
  fi
fi

if [ "$HISTFILE" = ~/.bash_history ]; then
  export HISTFILE=$HOME/.bash_history/$HISTNAME
  unset HISTNAME
fi

# Disable flow control
stty -ixon

# Disable history expansion
set +H


# Fix pintry-curses on CentOS, as per http://forums.gentoo.org/viewtopic-t-699598.html
#   > Turns out pinentry needs to know the TTY it should use. Apparently it's
#   > able to deduce this when it's run from the command line, but the pine
#   > ncurses interface confuses it.
#   >
#   > I added the following line (which came from the gpg-agent man page) to
#   > my ~/.bash_profile at the bottom and it works now:
# GPG always wants to know what TTY it's running on.
export GPG_TTY=$(tty)


if type vim >/dev/null 2>&1; then
  export EDITOR=vim
fi

# Stick all node stuff in here
export NODE_PATH="$HOME/.tools/localized/lib/node"

# Nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

export PYTHONSTARTUP="$HOME/.pythonrc"

# Set up chruby
if [ -f "/usr/local/opt/chruby/share/chruby/chruby.sh" ]; then
    source /usr/local/opt/chruby/share/chruby/chruby.sh
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

if [ -f ~/.tools/configs-private/machines/$(hostname -s).bashrc ]; then
  . ~/.tools/configs-private/machines/$(hostname -s).bashrc
fi

if [ -f ~/.tools/configs/machines/$(hostname -s).bashrc ]; then
  . ~/.tools/configs/machines/$(hostname -s).bashrc
fi
