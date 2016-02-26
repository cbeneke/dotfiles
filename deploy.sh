#!/bin/bash

# Main function
main() {
  [ $# -gt 0 ] && [ $1 == "-v" ] && verbose="true" || verbose=""
  path=$( cd $(dirname $0) && pwd)

  # Update symlinks in home
  for file in `ls ${path} | grep -vE "README\.md|deploy\.sh|config"`; do
    link ${path}/${file} ~/.${file} ${verbose}
  done

  mkdir -p ~/.config
  for file in `ls ${path}/config`; do
    link ${path}/config/${file} ~/.config/${file} ${verbose}
  done

  [ -z "$verbose" ] && echo "Files deployed"
}

# Usage: link target name [verbose]
# creates Symlink 'name -> target'
link() {
  target=$1
  name=$2
  [ $# -gt 2 ] && verbose="true" || verbose=""

  [ "x${verbose}" == 'x' ] || echo "> ${name}"

  # remove symlink if exists
  if [ -h ${name} ]; then 
    [ "x${verbose}" == 'x' ] || echo "  removing ${name}"
    rm ${name}
  else
    if [ -e ${name} ]; then
      echo "${name} exists and is not an symlink!"
      return
    fi
  fi

  [ "x${verbose}" == 'x' ] || echo "  creating new symlink: ${name} -> ${target}"
  ln -s ${target} ${name}
}

# run the programm
main $@

# vim:set et ts=2 sw=2 sts=2:
