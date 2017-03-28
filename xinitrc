#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

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


if [ $EUID -ne 0 ] ; then
    # start ssh-agent
    if [[ -n $SSH_AGENT_PID ]]; then
        eval "$(ssh-agent -k)"
    fi
    eval $(ssh-agent)

    # start daemons and tools
    type urxvtd >/dev/null && urxvtd -f
    type redshift >/dev/null && redshift -l 52.3:13.25 -m randr &
    type connman-ui-gtk >/dev/null && connman-ui-gtk &
    type xcompmgr >/dev/null && xcompmgr &
    type unclutter >/dev/null && unclutter &
    type nextcloud >/dev/null && nextcloud &
fi
exec awesome > .awesomeErrors
