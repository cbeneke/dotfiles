#!/bin/bash

# Main function
main() {
  [ $# -gt 0 ] && [ $1 == "-v" ] && verbose="true" || verbose=""
  path=$(pwd)

  # Update symlinks in home
  for file in `ls | grep -vE "README\.md|deploy\.sh|config"`; do
    link ${path}/${file} ~/.${file}
  done

  mkdir -p ~/.config
  for file in `ls config`; do
    link ${path}/config/${file} ~/.config/${file}
  done

  [ -z "$verbose" ] && echo "Files deployed"
}

# Usage: link target name
# creates Symlink 'name -> target'
link() {
  target=$1
  name=$2

  [ "x$verbose" == 'x' ] || echo "> ${name}"

  # remove symlink if exists
  if [ -h ${name} ]; then 
    [ "x$verbose" == 'x' ] || echo "  removing ${name}"
    rm ${name}
  else
    if [ -e ${name} ]; then
      echo "${name} exists and is not an symlink!"
      exit 1
    fi
  fi

  [ "x$verbose" == 'x' ] || echo "  creating new symlink: ${name} -> ${target}"
  ln -s ${target} ${name}
}

# run the programm
main()


# vim:set et ts=2 sw=2 sts=2:
