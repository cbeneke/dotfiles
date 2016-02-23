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

type redshift >/dev/null && redshift -l 52.3:13.25 -m randr &
type connman-ui-gtk >/dev/null && connman-ui-gtk &
#type owncloud >/dev/null && owncloud &
type xcompmgr >/dev/null && xcompmgr &
type urxvdt >/dev/null && urxvtd -f
type unclutter >/dev/null && unclutter &

exec awesome > .awesomeErrors
