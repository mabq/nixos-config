# --- Load external plugins ----------------------------------------------------

# ssh-agent is started as a service with systemd
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(atuin init zsh --disable-up-arrow)"

# asdf (https://asdf-vm.com/guide/getting-started.html#_3-install-asdf)
# (use the instructions of the "ZSH & Git" section, installation is done
# by cloning the repo, not with pacman).
# source "$HOME/.asdf/asdf.sh"
# fpath=(${ASDF_DIR}/completions $fpath)


# -- Basic auto/tab complete ---------------------------------------------------

#   Initialise completions with ZSH's compinit
#   (not actually a plugin but act as one)
# autoload -Uz compinit
# zstyle ":completion:*" menu select
# compinit
# _comp_options+=(globdots)   # include hidden files
