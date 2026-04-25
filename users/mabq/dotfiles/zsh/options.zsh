# General options --------------------------------------------------------------

# don't beep on error
setopt no_beep

# allow comments even in interactive shells
setopt interactive_comments

# show completion menu on successive tab press (needs unsetop menu_complete to work)
setopt auto_menu

# do not autoselect the first completion entry
unsetopt menu_complete

# allow completion from within a word/phrase
setopt complete_in_word

# spelling correction for commands
# setopt correct

# extended globbing, awesome!
setopt extendedGlob

# disable pause/resume output (Ctrl-s/Ctrl-q)
unsetopt flowcontrol


# History options --------------------------------------------------------------

# share history file accross all zsh instances
setopt share_history

# write each new command to the history file as soon as it's entered, rather than waiting until the end of the session
setopt inc_append_history

# save timestamp and command duration
setopt extended_history

# ignore all duplicate commands, regardless of whether they are consecutive or not
setopt hist_ignore_all_dups

# lose oldest duplicates first
setopt hist_expire_dups_first

# any command that starts with a space character will not be recorded in the command history --- useful to prevent accidentally storing sensitive or irrelevant commands in your history
setopt hist_ignore_space

# remove extra blanks from each command line being added to history
setopt hist_reduce_blanks

# show the recalled command on the command line for you to review
setopt hist_verify

