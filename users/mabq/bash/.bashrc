# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

source ~/.local/share/nixos-config/users/mabq/bash/envs
source ~/.local/share/nixos-config/users/mabq/bash/shell
source ~/.local/share/nixos-config/users/mabq/bash/aliases
source ~/.local/share/nixos-config/users/mabq/bash/functions
source ~/.local/share/nixos-config/users/mabq/bash/init
[[ $- == *i* ]] && bind -f ~/.local/share/nixos-config/users/mabq/bash/inputrc
