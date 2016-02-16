#!/bin/bash

[ $# -gt 0 ] && [ $1 == "-v" ] && verbose="true" || verbose=""
path=$(pwd)

# Update symlinks in home
for link in `ls | grep -vE "README\.md|deploy\.sh"`; do
  [ "x$verbose" == 'x' ] || echo "> ${link}"

  [ "x$verbose" == 'x' ] echo "  removing ~/.${link}"
  rm ~/.${link}

  [ "x$verbose" == 'x' ] || echo "  creating new symlink: ${path}/${link} -> ~/.${link}"
  ln -s ${path}/${link} ~/.${link}

done

[ -z "$verbose" ] && echo "Files deployed"

# vim:set et ts=2 sw=2 sts=2:
