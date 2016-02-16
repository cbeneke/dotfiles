Usage
-----

Add the following script to your git hooks to run the deploy script automatically when updating
the dotfiles:

'GIT_DIR/hooks/post-merge'
    #!/bin/bash

    # update local symlinks
    echo "Running Deploy Script:"
    exec $PWD/deploy.sh

