These are my dotfiles.
======================

The things you might be able to use the most are install.sh/uninstall.sh (and lib.sh).

I've also tried to add machine-specific configuration options at the end of all relevant files (.vimrc and .bashrc are the two big ones, although there might be others).


$(dirname "$0")-private
-----------------------
For things that you don't want tracked on Github, I've added a "\*-private" directory. It is named whatever this repo is, with -private tacked on the end. Dotfiles in there are sourced much like the files in this repo. I have my Password Gorilla database in there, and it might make sense to have a "machines/" directory in there as well (although that is not currently supported).

How can I use this repo?
------------------------

If you want to follow my directory structure, do this:

    mkdir ~/.tools/
    pushd ~/.tools/
    git init
    git submodule add https://github.com/blast-hardcheese/dotfiles configs
    mkdir configs-private  # If you actually need this
    git commit -m "Added blast-hardcheese's awesome dotfiles"
    popd
    ~/.tools/configs/install.sh

If you don't want to follow my directory structure, do something else:

    git clone https://github.com/blast-hardcheese/dotfiles ~/.blast-dotfiles/
    mkdir ~/.blast-dotfiles-private
    ~/.blast-dotfiles/install.sh

Or just take install.sh, uninstall.sh, and lib.sh and do your own thing (it's really OK).

Useful things
=============

`.auth_sockrc`
-------------

This provides some support for managing ssh-agent sockets. Tested and used for years on both Linux and OSX.

    as_start: Start an ssh-agent and register it
    as_use: Use a registered ssh-agent
    as_register: Write the contents of SSH_AUTH_SOCK into the appropriate place
    as_revert: If you want to revert back to what socket you were using _before_
               as_use, use this. Useful for if you ssh -A to a box that already
               has ssh-agent running, but you want to use your forwarded agent.

`.bin/i3tagger`
-------------

wmii-style tag support for i3. Mod+t to tag your windows with whatever workspace name you want!

`.bin/_tmux_start-session`
------------------------

Reasonably flexible tmux workspace generation! Examples are in [work](.bin/work) and [vocities](.bin/vocities), and a somewhat helpful error text is displayed on stderr when run directly (as it is intended to be _sourced_ into another script that provides configuration information. If necessary, the `tmux_after` function can be defined before sourcing `_tmux_start-session`, in order to customize environment startup before attaching. **NOTE:** These names are not noconflicted, so their names may change in the future.

Contribution/Attribution
------------------------

If any of this helped you in any way, I'd really appreciate an email! If something's broken, open an issue or send a pull request! If you take any or all of install.sh, uninstall.sh, and lib.sh and do something cool, let me know!
