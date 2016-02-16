#!/bin/bash

[ $# -gt 0 ] && [ $1 == "-v" ] && verbose="true" || verbose=""
path=$(pwd)

# Update symlinks in home
for link in `ls | grep -vE "README\.md|deploy\.sh|config"`; do
  [ "x$verbose" == 'x' ] || echo "> ${link}"

  # remove symlink if exists
  if [ -e ~/.${link} ]; then 
    [ "x$verbose" == 'x' ] || echo "  removing ~/.${link}"
    if [ -h ~/.${link} ]; then
      rm ~/.${link}
    else
      echo "~/.${link} exists and is not an symlink!"
      exit 1
    fi
  fi

  [ "x$verbose" == 'x' ] || echo "  creating new symlink: ${path}/${link} -> ~/.${link}"
  ln -s ${path}/${link} ~/.${link}
done

for link in `ls config`; do
  [ "x$verbose" == 'x' ] || echo "> ${link}"

  # remove symlink if exists
  if [ -e ~/.config/${link} ]; then 
    [ "x$verbose" == 'x' ] || echo "  removing ~/.config/${link}"
    if [ -h ~/.config/${link} ]; then
      rm ~/.config/${link}
    else
      echo "~/.config/${link} exists and is not an symlink!"
      exit 1
    fi
  fi

  [ "x$verbose" == 'x' ] || echo "  creating new symlink: ${path}/config/${link} -> ~/.config/${link}"
  ln -s ${path}/config/${link} ~/.config/${link}
done

[ -z "$verbose" ] && echo "Files deployed"

# vim:set et ts=2 sw=2 sts=2:
