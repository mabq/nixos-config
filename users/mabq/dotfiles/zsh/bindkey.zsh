# Use vi mode instead of emacs (default)
bindkey -v

# Zsh bug fix (https://github.com/spaceship-prompt/spaceship-prompt/issues/91#issuecomment-327996599)
bindkey '^?' backward-delete-char

# Launch tmux-sessionizer with Ctrl-/
bindkey -s '^s' "$HOME/.config/tmux/scripts/tmux-sessionizer.sh\n"
#bindkey -s '^_' "$HOME/.config/zellij/scripts/zellij-sessioniner.sh\n"

# History search up/down arrows (requires zsh-history-substring-search plugin)
# (disabled because now we are using atuin)
# bindkey '^[[A' history-substring-search-up    # up arrow
# bindkey '^[[B' history-substring-search-down  # donw arrow

