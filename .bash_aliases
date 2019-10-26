if type xclip >/dev/null 2>&1 && [ -n "$DISPLAY" ]; then
    XCLIP_IN="xclip -i";
    XCLIP_OUT="xclip -o";
elif type pbcopy >/dev/null 2>&1; then
    XCLIP_IN="pbcopy";
    XCLIP_OUT="pbpaste";
else
    unset XCLIP_IN
    unset XCLIP_OUT
fi

alias urlquote='python2.7 -c "import urllib, sys; _in = (sys.argv[1] if len(sys.argv) > 1 else raw_input()); print urllib.quote(_in)"'

alias pssh="ssh -o 'ProxyCommand /usr/bin/env nc -x localhost:5000 %h %p'"
alias pscp="scp -o 'ProxyCommand /usr/bin/env nc -x localhost:5000 %h %p'"

alias runwine="DYLD_FALLBACK_LIBRARY_PATH=/usr/X11/lib wine"

WHICH='/usr/bin/which --tty-only --read-alias --show-dot --show-tilde'
ALIAS="alias | $WHICH"
if echo -n | $WHICH vim >/dev/null 2>&1; then
    alias which="$ALIAS"
fi

alias x_register='echo $DISPLAY > ~/.xsession_var'
alias x_use='export DISPLAY=$(cat ~/.xsession_var)'

alias chat='ssh scyther -t tmux attach -t chat'
alias mv='/bin/mv -i'

alias cd..='cd ..'
alias gt='git'

if ls --color &>/dev/null ; then
    alias ls="ls --color=auto -I '*.pyc'"
fi

alias mkdate="mkdir -v $(date +'%Y-%m-%d')"

alias ve='source ~/.virtualenv/bin/activate'
alias ve27='source ~/.virtualenv2.7/bin/activate'

# neovim adapters
alias vim=nvim
alias vimdiff="nvim -d"
alias view="nvim -R"

if [ -f ~/.tools/configs/machines/$(hostname -s).bash_aliases ]; then
  . ~/.tools/configs/machines/$(hostname -s).bash_aliases
fi
