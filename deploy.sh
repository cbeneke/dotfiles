#!/bin/bash

[ $# -gt 0 ] && [ $1 == "-v" ] && verbose="true" || verbose=""
path=$(pwd)

# Update symlinks in home
for link in `ls | grep -vE "README\.md|deploy\.sh"`; do
    if [ -n "$verbose" ]; then
    echo "$link"
        echo "  removing ~/.$link"
    fi
    rm -r ~/.$link

    if [ -n "$verbose" ]; then
        echo "  creating new symlink: $path/$link -> ~/.$link"
    fi
    ln -s $path/$link ~/.$link
done
[ -z "$verbose" ] && echo "Files deployed"
