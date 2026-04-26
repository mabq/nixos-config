# -- Completion
# setopt no_menu_complete # Do not autoselect the first completion entry

# -- Expansion and globing
# setopt extendedGlob # Treat the `#', `~' and `^' characters as part of patterns for filename generation, etc.

# -- History
# setopt extended_history # Save timestamp and command duration
# setopt no_hist_beep
# setopt hist_expire_dups_first # Lose oldest duplicates first
# setopt hist_ignore_all_dups # Ignore all duplicate commands, regardless of whether they are consecutive or not
# setopt hist_ignore_space # Any command that starts with a space character will not be recorded in the command history --- useful to prevent accidentally storing sensitive or irrelevant commands in your history
# setopt hist_reduce_blanks # Remove extra blanks from each command line being added to history
# setopt hist_verify # Show the recalled command on the command line for you to review
# setopt inc_append_history # Write each new command to the history file as soon as it's entered, rather than waiting until the end of the session
# setopt share_history # Share history file accross all zsh instances

# -- Input/output section
# setopt interactive_comments # Allow comments even in interactive shells
# setopt no_correct # Try  to  correct the spelling of commands.
# setopt no_flow_control # Disable pause/resume output (Ctrl-s/Ctrl-q)

# -- Zle (Zsh Line Editor)
setopt no_beep # Don't beep on error

