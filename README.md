Michael Leuchtenburg's Dotfiles
===============================

Installation
------------

First, install homeshick:
    git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
    printf '\nsource "$HOME/.homesick/repos/homeshick/homeshick.sh"' >> $HOME/.bashrc
    # or maybe
    printf '\nsource "$HOME/.homesick/repos/homeshick/homeshick.sh"' >> $HOME/.zshrc
    # open a new shell

Next, clone this repo and link:
    homeshick clone dyfrgi/dotfiles
    homeshick link
