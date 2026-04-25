# Edit the PATH variable:
#   (the `appendToPATH_fn` functions avoids duplicate entries in $PATH)
#   (`~/.local/bin` contains the custom scripts that are called from the terminal)
appendToPATH_fn "$HOME/.local/bin"
appendToPATH_fn "$HOME/.nix-profile/bin"
# appendToPATH_fn "$HOME/go/bin"
# appendToPATH_fn "$HOME/.cargo/bin"
#prependToPATH_fn "$HOME/.volta/bin"

# History options:
#   Export them so that atuin can see the variables content
export HISTSIZE=10000
export SAVEHIST="${HISTSIZE}"
export HISTFILE=~/.cache/zsh/history  # be careful not to include this file on any git repo


# XDG Base Directory:
#   Only XDG_RUNTIME_DIR is set by default through pam_systemd(8). It is up to the user to explicitly define the other variables according to the specification.
#   https://wiki.archlinux.org/title/XDG_Base_Directory#User_directories
export XDG_CONFIG_HOME="$HOME/.config"  # $HOME value is taken from `/etc/passwd`
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DATA_DIRS="/usr/local/share:/usr/share:/var/lib/flatpak/exports/share:/home/mabq/.local/share/flatpak/exports/share" # show flatpak applications in open menu
export XDG_CONFIG_DIRS="/etc/xdg"


# SSH-agent:
#   Required for the ssh-agent to work across terminals
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"  # https://wiki.archlinux.org/title/SSH_keys#Start_ssh-agent_with_systemd_user


# Defaults:
#   These variables define default applications when executing commands from the terminal.
#   Do not set the `TERM` variable!, it is set by each terminal emulator.
export BROWSER="brave"  # when opening links
export VISUAL="nvim"  # when opening a GUI editor (nnn `-e` option will respect this variable)
export EDITOR="nvim"  # when opening a terminal editor
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export PAGER="less -R --use-color -Dd+r -Du+b"
export MANROFFOPT="-P -c"  # https://wiki.archlinux.org/title/Color_output_in_console#Using_less
# export GPG_TTY="${TTY:-$(tty)}"
# export VOLTA_HOME="$XDG_CONFIG_HOME/.volta" # The hassle-free JavaScript Tools Manager


# n Node Manager (see http://git.io/n-install-repo)
export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"


# Colors:
# export BAT_THEME=""
export GTK_THEME="Adwaita:dark"

# fzf tokyonight: https://github.com/folke/tokyonight.nvim/tree/main/extras/fzf
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none
  --color=bg+:#283457 \
  --color=bg:#16161e \
  --color=border:#27a1b9 \
  --color=fg:#c0caf5 \
  --color=gutter:#16161e \
  --color=header:#ff9e64 \
  --color=hl+:#2ac3de \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#2ac3de \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#27a1b9 \
  --color=separator:#ff9e64 \
  --color=spinner:#ff007c \
"
