################################################################################
#{{{ TODOS
#   git functionality
#
#
#}}}
#{{{ helper functions
################################################################################

hascmd() {
    type &> /dev/null $1 && return 0 || return 1
}

mkcd() {
    mkdir $1 && cd $1
}

#function git_prompt() {
#    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref=$(git rev-parse --short HEAD 2>/dev/null)
#    if [[ -n "$ref" ]]; then
#        echo "( git ) "
#    fi
#}

################################################################################
#}}}
#{{{ environment for external tools
################################################################################

# include virtualenvwrapper
[ -z ${VIRTUALENVSH} ] && export VIRTUALENVSH='/usr/bin/virtualenvwrapper.sh'
if [ -f ${VIRTUALENVSH} ]; then
    [ -z ${WORKON_HOME} ] && export WORKON_HOME="${HOME}/.virtualenvs"
    source ${VIRTUALENVSH}
fi

# set qemu:///system as default connection for virsh
export LIBVIRT_DEFAULT_URI='qemu:///system'

[ -r ${HOME}/bin ] && PATH="${PATH}:${HOME}/bin"
export PATH

# include the z script
[ -x ${HOME}/.z.sh ] && . ${HOME}/.z.sh

hascmd dircolors && eval $(dircolors -b) # color setup for ls

# which version of vi to use
if hascmd nvim; then
    export EDITOR=${EDITOR:-nvim}
elif hascmd vim ; then
    export EDITOR=${EDITOR:-vim}
else
    export EDITOR=${EDITOR:-vi}
fi

# use vimpager or less as PAGER
if hascmd vimpager ; then
    export PAGER=${PAGER:-vimpager}
else
    export PAGER=${PAGER:-less}
fi

# support colors in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

export LS_COLORS='rs=0:di=01;36:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';

# disable mailchecks
export MAILCHECK=""

################################################################################
#}}}
#{{{ zsh parameters & options
################################################################################

HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILE=$HOME/.zsh_history
ZSHDIR=${HOME}/.zsh

setopt nobeep               # don't beep

setopt pushd_ignore_dups    # don't push the same dir twice.

setopt inc_append_history   # the history entry is written out to the file after the command is finished,
                            # rather than waiting until the shell exits
                            # Tip: import new commands from $HISTFILE with: fc -R


setopt extended_history     # save each command's beginning timestamp and
                            # the duration to the history file

setopt histignorealldups    # when a new command is added to history, older
                            # duplicates are removed

setopt histignorespace      # don't save a command to history if first character
                            # on the line is space

setopt hist_fcntl_lock      # use fcntl $HISTFILE locking where available


setopt extended_glob        # Treat the `#', `~' and `^' characters as part of
                            # patterns for filename generation
                            # *~(*.gz|*.bz|*.bz2|*.zip|*.Z) -> searches for word
                            # not in compressed files

setopt completeinword       # <TAB> completes not just at the end of a word

setopt always_to_end        # When completing from the middle of a word, move the
                            # cursor to the end of the word

setopt norecexact           # show completion menu even if input matches one option
                            # completely. Without this ls<TAB> will just give ls.
                            # With this, ls<TAB> will also list things like lspci

setopt hash_list_all        # whenever a command completion is attempted, make sure
                            # the entire command path is hashed first.

setopt correct              # try to correct typos

################################################################################
#}}}
#{{{ prompt
#    see man 1 zshmisc for explanation of escape codes
################################################################################

# exit code on the left if != 0, red username for root, green otherwise
#PROMPT="%(!.%B%F{red}.%F{green})%B%n [%m]%b %{%B%F{white}%}%B%d%b $(git_prompt)
#%(!.#.$) "
PROMPT="%{%B%F{gray}%}%D{%H:%M}%b %(!.%B%F{red}.%F{green})%B%n [%m]%b %{%B%F{white}%}%B%d%b
%(!.#.$) "
RPROMPT="%(?..%B%F{red}[%?]%b)"

# printed when waiting for more input
PS2="%F{green}%_%f> "
# when debugging with set -x: file in blue, linenum in green
PS4="+%F{blue}%N%f:%F{green}%i%f> "

TMOUT=30

TRAPALRM() {
    zle reset-prompt
}

################################################################################
#}}}
#{{{ keybindings
################################################################################

H-keybindings() {
# this is included in H-zsh()
# PLEASE UPDATE WHEN YOU CHANGE SOMETHING
cat <<ENDHELP
Useful keybindings:
  Ctrl-Left/Right --  Jump words
  Alt-Left/Right  --  Jump words bash style (boundary on "/")
  Alt-.           --  insert last word of last command
  Ctrl-g          --  send-break (also aborts completion)
  Ctrl-o          --  in complete menu: accept choice and continue completion
  Ctrl-x u        --  undo (try in combination with Ctrl-o in completion menu)
  Ctrl-x Ctrl-x   --  complete word from history with menu

Extra special keybindings:
  Ctrl-x h        --  add a cmdline to history without executing it
                      (you can also prefix the cmdline with space)
  Ctrl-x d        --  insert date YYYY-MM-DD
  Ctrl-x e        --  edit current commandline in $EDITOR
  Ctrl-x i        --  insert unicode char: Ctrl-x i 00A7 Ctrl-x i
  Ctrl-x 1        --  jump to after first word (for adding options)
ENDHELP
}
# use vi mode as default
bindkey -v

# bind to multiple maps
function bind2maps () {
    local i sequence widget
    local -a maps

    while [[ "$1" != "--" ]]; do
        maps+=( "$1" )
        shift
    done
    shift

    if [[ "$1" == "-s" ]]; then
        shift
        sequence="$1"
    else
        sequence="${key[$1]}"
    fi
    widget="$2"

    [[ -z "$sequence" ]] && return 1

    for i in "${maps[@]}"; do
        bindkey -M "$i" "$sequence" "$widget"
    done
}

# Make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

typeset -A key
key=(
    Home     "${terminfo[khome]}"
    End      "${terminfo[kend]}"
    Insert   "${terminfo[kich1]}"
    Delete   "${terminfo[kdch1]}"
    Up       "${terminfo[kcuu1]}"
    Down     "${terminfo[kcud1]}"
    Left     "${terminfo[kcub1]}"
    Right    "${terminfo[kcuf1]}"
    PageUp   "${terminfo[kpp]}"
    PageDown "${terminfo[knp]}"
    BackTab  "${terminfo[kcbt]}"
)

# bind those keys that many expect to work
bind2maps emacs             -- Home   beginning-of-line
bind2maps       viins vicmd -- Home   vi-beginning-of-line
bind2maps emacs             -- End    end-of-line
bind2maps       viins vicmd -- End    vi-end-of-line
bind2maps emacs viins       -- Insert overwrite-mode
bind2maps             vicmd -- Insert vi-insert
bind2maps emacs             -- Delete delete-char
bind2maps       viins vicmd -- Delete vi-delete-char
bind2maps emacs viins vicmd -- Up     up-line-or-search
bind2maps emacs viins vicmd -- Down   down-line-or-search
bind2maps emacs             -- Left   backward-char
bind2maps       viins vicmd -- Left   vi-backward-char
bind2maps emacs             -- Right  forward-char
bind2maps       viins vicmd -- Right  vi-forward-char
bind2maps       viins vicmd -- Right  vi-forward-char

if autoload history-search-end; then
    zle -N history-beginning-search-backward-end history-search-end
    zle -N history-beginning-search-forward-end  history-search-end
    # search history backward for entry beginning with typed text
    bind2maps emacs viins       -- PageUp history-beginning-search-backward-end
    # search history forward for entry beginning with typed text
    bind2maps emacs viins       -- PageDown history-beginning-search-forward-end
fi

# Ctrl-a: jump to beginning of line
bind2maps viins -- -s "^A" beginning-of-line

# Ctrl-e: jump to end of line
bind2maps viins -- -s "^E" end-of-line

# Ctrl-f: forward char
bind2maps viins -- -s "^F" forward-char

# Ctrl-b: backward char
bind2maps viins -- -s "^B" backward-char

# Ctrl-p: previous history
bind2maps viins -- -s "^P" vi-up-line-or-history

# Ctrl-n: next history
bind2maps viins -- -s "^N" vi-down-line-or-history

# Ctrl-r: use the new *-pattern-* widgets for incremental history search
bind2maps emacs viins vicmd -- -s '^R' history-incremental-pattern-search-backward

# Alt-.: insert last word of last command like in emacs mode
bind2maps viins -- -s '\e.' insert-last-word

# Ctrl-x u: Undo last text modification (also while completing)
bind2maps viins -- -s '^Xu' undo

# Ctrl-x Ctrl-x: complete word from history with menu
bind2maps emacs viins       -- -s "^x^x" hist-complete

## Ctrl-Left and Ctrl-Right: jumping to word-beginnings on the command line.
# URxvt sequences:
bind2maps emacs viins vicmd -- -s '\eOc' forward-word
bind2maps emacs viins vicmd -- -s '\eOd' backward-word
# These are for xterm:
bind2maps emacs viins vicmd -- -s '\e[1;5C' forward-word
bind2maps emacs viins vicmd -- -s '\e[1;5D' backward-word
# Also try ESC Left/Right:
bind2maps emacs viins vicmd -- -s '\e'${key[Right]} forward-word
bind2maps emacs viins vicmd -- -s '\e'${key[Left]}  backward-word

## Alt-Left and Alt-Right: the same but bash style: "/" is a word a boundary
bash-forward-word() {
    local WORDCHARS="${WORDCHARS:s@/@}"
    zle forward-word
}
zle -N bash-forward-word
bash-backward-word() {
    local WORDCHARS="${WORDCHARS:s@/@}"
    zle backward-word
}
zle -N bash-backward-word

# URxvt again:
bind2maps emacs viins vicmd -- -s '\e\e[C' bash-forward-word
bind2maps emacs viins vicmd -- -s '\e\e[D' bash-backward-word
# Xterm again:
bind2maps emacs viins vicmd -- -s '^[[1;3C' bash-forward-word
bind2maps emacs viins vicmd -- -s '^[[1;3D' bash-backward-word

zmodload -i zsh/complist && {
    # Ctrl-o: while in completion menu accept a completion and try to complete
    # again by using menu completion; very useful with completing directories by
    # using 'undo' one's got a simple file browser
    bind2maps menuselect -- -s '^o' accept-and-infer-next-history    \

    # Shift-tab: Perform backwards menu completion
    bind2maps menuselect -- BackTab reverse-menu-complete

    } || print "No complist module available"

# Ctrl-x d: insert date YYYY-MM-DD
insert-timestamp() { BUFFER="$BUFFER$(date '+%F')"; CURSOR=$#BUFFER; }
zle -N insert-timestamp
bind2maps emacs viins -- -s '^xd' insert-timestamp

# Ctrl-x e: edit current commandline in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bind2maps emacs viins vicmd -- -s '^xe' edit-command-line


################################################################################
#}}}
#{{{ Completion
################################################################################

# syntax:
# zstyle :completion:<function>:<completer>:<command>:<arg>:<tag> style value

# colorize completion
zstyle ':completion:*'                list-colors ${(s.:.)LS_COLORS}

# separate matches into groups
zstyle ':completion:*'                group-name ''

# menu selection for all completions
zstyle ':completion:*' menu select=1

# formats
zstyle ':completion:*:warnings'       format $'%F{red}No matches for:%f %d'
zstyle ':completion:*:messages'       format '%d'
zstyle ':completion:*:descriptions'   format $'%F{red}completing %B%d%b%f'
zstyle ':completion:*:corrections'    format $'%F{red}completing %B%d%b%F{red} (%e errors)%f'

# verbose descriptions (include explanation of options)
zstyle ':completion:*'                 verbose yes

# prompt to show when scrolling in output longer than screen
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

# complete manpages by section
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true

# history completion
zle -C hist-complete complete-word _generic
zstyle ':completion:hist-complete:*' completer _history

# ignore duplicate entries
zstyle ':completion:*:history-words'  remove-all-dups yes
zstyle ':completion:*:history-words'  stop yes

# match uppercase from lowercase
zstyle ':completion:*'                matcher-list 'm:{a-z}={A-Z}'

# provide .. as a completion
zstyle ':completion:*' special-dirs ..

# allow one error for every three characters typed in approximate completer
zstyle ':completion:*:approximate'    max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )'

# Ignore completion functions for commands you don't have:
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'

# group original command first, so that it is not immediately replaced
# TODO: not sure if this is the right way to achieve this.
zstyle ':completion::*approximate*:*' group-order original corrections

# don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '(aptitude-*|*\~)'

# format for process list on kill completion
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,start_time,cmd -w -w"

# Provide more processes in completion of programs like killall:
zstyle ':completion:*:processes-names' command 'ps -u ${USER} -o command | uniq'

# Search path for sudo completion
zstyle ':completion:*:sudo:*' command-path  /usr/local/sbin \
                                            /usr/local/bin  \
                                            /usr/sbin       \
                                            /usr/bin        \
                                            /sbin           \
                                            /bin

# run rehash on completion so new installed program are found automatically:
_force_rehash() {
    (( CURRENT == 1 )) && rehash
    return 1
}

zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete _files _ignored _approximate

# caching
[[ -d $ZSHDIR/cache ]] && zstyle ':completion:*' use-cache yes && \
    zstyle ':completion::complete:*' cache-path $ZSHDIR/cache/

if autoload -Uz compinit; then
    compinit || print 'Notice: no compinit available'
fi

# use generic completion system for programs not yet defined; (_gnu_generic works
# with commands that provide a --help option with "standard" gnu-like output.)
for compcom in cp deborphan df feh fetchipac gpasswd head hnb ipacsum mv \
                pal stow tail uname ; do
    [[ -z ${_comps[$compcom]} ]] && compdef _gnu_generic ${compcom}
done; unset compcom

# show three dots while completing
expand-or-complete-with-dots() {
     echo -n "\e[32m...\e[0m"
     zle expand-or-complete
     zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots


################################################################################
#}}}
#{{{ common aliasas
################################################################################

# Exception for ls: With --color=auto, ls emits color codes only when standard
# output is connected to a terminal -> does not break stuff, allowed
alias ls="ls --color=auto --group-directories-first"
alias l="ls -lF"
alias ll="l"
alias la="ls -laF"
alias lla="la"
alias c='cd'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias si='sudo su'
alias :q='exit'
if hascmd nvim ; then
    alias vim='nvim'
fi

if hascmd yaourt ; then
    alias yaourt-clean='[[ -n "`yaourt -Qdtq`" ]] && yaourt -Rs $(yaourt -Qdtq) || echo ":: No package to remove"'
    alias yau='yaourt -Syau && echo "" && yaourt-clean'
fi

################################################################################
#}}}
#{{{ useful shell functions
###############################################################################
# None

###############################################################################
#}}}
#{{{ custom help texts
################################################################################

H-zsh() {
cat <<ENDHELP
See also help-zsh-glob for help on globbing patterns.

Tips:
  o prefix a command line with <space> to exclude it from history
  o you have autocompletion for kill and killall

Useful Commands:
  fc -R            -- Read new entries (from other instances) from $HISTFILE"
  bindkey -Ll      -- List all keymaps (and see which is linked to main)
  bindkey -L       -- List keybindings (you can specify a map with -M)
  bindkey -e       -- switch to emacs mode
  bindkey -v       -- switch to vi mode
  setopt [option]  -- list or set shell options
  unsetopt         -- unset shell options

ENDHELP
H-keybindings
}
alias help-zsh=H-zsh

# Provides useful information on globbing
H-Glob() {
cat <<ENDHELP
    /      directories
    .      plain files
    @      symbolic links
    =      sockets
    p      named pipes (FIFOs)
    *      executable plain files (0100)
    %      device files (character or block special)
    %b     block special files
    %c     character special files
    r      owner-readable files (0400)
    w      owner-writable files (0200)
    x      owner-executable files (0100)
    A      group-readable files (0040)
    I      group-writable files (0020)
    E      group-executable files (0010)
    R      world-readable files (0004)
    W      world-writable files (0002)
    X      world-executable files (0001)
    s      setuid files (04000)
    S      setgid files (02000)
    t      files with the sticky bit (01000)

  print *(m-1)          # Files modified up to a day ago
  print *(a1)           # Files accessed a day ago
  print *(@)            # Just symlinks
  print *(Lk+50)        # Files bigger than 50 kilobytes
  print *(Lk-50)        # Files smaller than 50 kilobytes
  print **/*.c          # All *.c files recursively starting in \$PWD
  print **/*.c~file.c   # Same as above, but excluding 'file.c'
  print (foo|bar).*     # Files starting with 'foo' or 'bar'
  print *~*.*           # All Files that do not contain a dot
  chmod 644 *(.^x)      # make all plain non-executable files publically readable
  print -l *(.c|.h)     # Lists *.c and *.h
  print **/*(g:users:)  # Recursively match all files that are owned by group 'users'
  echo /proc/*/cwd(:h:t:s/self//) # Analogous to >ps ax | awk '{print $1}'<"
ENDHELP
}
alias help-zsh-glob=H-Glob

###############################################################################
#}}}
#{{{ finalizing
################################################################################

# remove functions that aren't needed anymore
unset -f bind2maps

#}}}
# vim:filetype=zsh autoindent expandtab shiftwidth=4 foldmethod=marker foldlevel=0
