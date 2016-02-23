#!/bin/bash

[ $# -gt 0 ] && [ $1 == "-v" ] && verbose="true" || verbose=""
path=$(pwd)

# Update symlinks in home
for link in `ls | grep -vE "README\.md|deploy\.sh|config"`; do
  [ "x$verbose" == 'x' ] || echo "> ${link}"

  # remove symlink if exists
  if [ -h ~/.${link} ]; then 
    [ "x$verbose" == 'x' ] || echo "  removing ~/.${link}"
    rm ~/.${link}
  else
    if [ -e ~/.${link} ]; then
      echo "~/.${link} exists and is not an symlink!"
      exit 1
    fi
  fi

  [ "x$verbose" == 'x' ] || echo "  creating new symlink: ${path}/${link} -> ~/.${link}"
  ln -s ${path}/${link} ~/.${link}
done

for link in `ls config`; do
  [ "x$verbose" == 'x' ] || echo "> ${link}"

  mkdir -p ~/.config

  # remove symlink if exists
  if [ -h ~/.config/${link} ]; then 
    [ "x$verbose" == 'x' ] || echo "  removing ~/.config/${link}"
    rm ~/.config/${link}
  else
    if [ -e ~/.config/${link} ]; then
      echo "~/.config/${link} exists and is not an symlink!"
      exit 1
    fi
  fi

  [ "x$verbose" == 'x' ] || echo "  creating new symlink: ${path}/config/${link} -> ~/.config/${link}"
  ln -s ${path}/config/${link} ~/.config/${link}
done

[ -z "$verbose" ] && echo "Files deployed"

# vim:set et ts=2 sw=2 sts=2:
