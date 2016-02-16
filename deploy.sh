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


# Set the correct access modes on SSH releated files
[ -n "$verbose" ] && echo "Changing mod of ssh keys to 600 (private) and 644 (public)"
chmod 600 $path/ssh/*
chmod 644 $path/ssh/*\.pub

for file in authorized_keys config known_hosts; do
    [ -n "$verbose" ] && [ -e $path/ssh/config ] && echo "changing mod of $path/ssh/$file to 644"
    [ -e $path/ssh/config ] && chmod 644 $path/ssh/$file
done
[ -z "$verbose" ] && echo "SSH file access checked"
