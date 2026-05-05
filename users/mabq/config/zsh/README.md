# Zsh config files explained

Zsh sources different files depending on the shell type.

Invariably the first file to be sourced is `/etc/zshenv` regardless of the shell type. NixOS puts only necessary stuff in there, it sets some global variables and configures the `fpath` variable to show zsh where it can find all files for autocomplition in the Nix Store. We cannot avoid this file from being sourced but it does not matter since nothing there affects our config.

Right after that `~/.zshenv` is sourced regardless of the shell type, so we must only include very specific stuff in there. Its content is produced by the user's `home-manager.nix` file. There we show zsh where to look for its config files via the `ZDOTDIR` variable, and also set the `REPO_USER_PATH` which can be used inside zsh config files to find the cloned repository files. More importantly we set the option `NO_GLOBAL_RCS` which instructs zsh not to load other global zsh config files, like `/etc/zshrc` which includes things we dont need (slowing down the init process) and has some weird keybinds that mess up out configs.

`/etc/zshrc` will be ignored and our `~/.zshrc` file will source our config files.


## Shell Types
--------------

- Login shell - first shell after authentication.
  E.g. SSH session, tty login, `zsh --login`

- Interactive shell - accepts commands from user, shows prompt.
  E.g. Terminal emulator window.

- Non-interactive shell - running scripts.
  E.g. `zsh -c <command>`.


## File Sourcing Order
----------------------

Login shells (both interactive and non-interactive):

  1. `/etc/zshenv`     (Always, for all shells - be careful!)
  2. `~/.zshenv`       (Always, for all shells)
  3. `/etc/zprofile`   (Login shells only)
  4. `~/.zprofile`     (Login shells only)
  5. `/etc/zshrc`      (Interactive shells)
  6. `~/.zshrc`        (Interactive shells)
  7. `/etc/zlogin`     (Login shells)
  8. `~/.zlogin`       (Login shells)

Interactive Non-Login Shells (e.g., terminal emulator):

  1. `/etc/zshenv`
  2. `~/.zshenv`
  3. `/etc/zshrc`
  4. `~/.zshrc`

Non-Interactive Non-Login Shells (scripts, commands with `-c`):

  1. `/etc/zshenv`
  2. `~/.zshenv`

Login Shell Exit (when you type `exit` or logout):

  1. `~/.zlogout`
  2. `/etc/zlogout`

