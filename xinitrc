#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Load keymap
if [ -s ~/.Xmodmap ]; then
    xmodmap ~/.Xmodmap
fi

#start autostart daemons and tools
redshift -l 52.3:13.25 -m randr &
connman-ui-gtk &
#owncloud &
xcompmgr &
urxvtd -f
unclutter &

exec awesome > .awesomeErrors
