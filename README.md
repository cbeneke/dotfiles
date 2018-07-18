Disclaimer
---
This repository is obsolet (replaced with https://github.com/cbeneke/ansible-dotfiles) and will no longer be maintained. The configs will be outdated by time.


Description
---
This are the my dotfiles. The deploy script creates symlinks from your home to any file or
directory located in it (or the config folder, which does not get linked directly but the files
in the folder are linked to your ${HOME}/.config folder). If you want to copy the files instead
use the `--copy` switch. BEWARE: If these files are already in your home they will be deleted
unconditonally. To check, what the script will do, use the `--pretend` switch.

Used programs
---
- awesome WM
- neovim
- terminus-font
- tmux
- vimpager
- wqi-zenhai
- zsh

Usage
---

    Usage: $0 [OPTIONS]

    OPTIONS
      -h | --help
        prints this helptext.

      -c | --copy
        instead of symlinking, copy files.

      -f | --force
        In symlink mode: remove existing files.

      -p | --pretend
        do not actually do something, just print actions (enables verbose mode).

      -v | --verbose
        give more output.

      -x | --no-color
        disable colorazation of the text.

Automatic installation
---
Add the following script to your git hooks to run the deploy script automatically when updating
the dotfiles:

'GIT\_DIR/hooks/post-merge'

    #!/bin/bash
    # update local symlinks
    echo "Running Deploy Script:"
    exec $PWD/deploy.sh -x
