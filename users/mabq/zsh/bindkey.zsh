# Use vi mode instead of emacs (default)
bindkey -v
# Zsh bug fix (https://github.com/spaceship-prompt/spaceship-prompt/issues/91#issuecomment-327996599)
bindkey '^?' backward-delete-char

# Bind Ctrl+Left and Ctrl+Right to move by words
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Control + Backspace to delete a word backward
bindkey '^H' backward-kill-word # common sequence for Ctrl+Backspace
bindkey '^[[3;5~' backward-kill-word # alternative sequence used by some terminals

# Launch tmux-sessionizer with Ctrl-/
# bindkey -s '^s' "$HOME/.config/tmux/scripts/tmux-sessionizer.sh\n"
#bindkey -s '^_' "$HOME/.config/zellij/scripts/zellij-sessioniner.sh\n"

# History search up/down arrows (requires zsh-history-substring-search plugin)
# (disabled because now we are using atuin)

