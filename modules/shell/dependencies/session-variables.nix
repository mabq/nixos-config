{
  repoDir,
  themeDir,
  ...
}:
{
  environment.sessionVariables = {

    # Used by some config files to avoid hard-coding the repo directory.
    REPODIR = "${repoDir}";

    # Used by some config files that admit global variables to avoid
    # hard-coding the theme path.
    THEMEDIR = "${themeDir}";

    # Include repo binaries
    PATH = "${repoDir}/bin"; # do not use `<path>:$PATH` syntax here

    # Other useful variables
    PAGER = "less -R --use-color -Dd+r -Du+b"; # colorized pager
    MANPAGER = "less -R --use-color -Dd+r -Du+b"; # colorized man pages
    MANROFFOPT = "-P -c"; # https://wiki.archlinux.org/title/Color_output_in_console#Using_less
    # TERM = # do not set this variable, it is set by each terminal emulator.
  };
}

/*
  What variables go here?
  -----------------------

  - Fixed variables
    The values of these variables are known ahead of time. For dynamic
    variables (created by programs at runtime) see the uwsm nix module.

  - Shared variables
    These variables will be used by all shells (Bash, Zsh, Fish).

  Where are these variables written?
  ----------------------------------

  These variables are written to `/etc/set-environment`.

  Where are these variables available?
  ------------------------------------

  - Non-interactive and interactive shells
    NixOS automatically configures all shells (Bash, Zsh, Fish) to source
    `/etc/set-environment` (see `/etc/zshenv`).

  - Systemd user services
    NixOS automatically runs a service during login (`import-environment`) that
    pushes the variables in `/etc/set-environment` into the `systemd --user`
    instance via `systemctl --user import-environment`.

  - NOT systemd system services
    Global system daemons (like `sshd`, `nginx`, or `docker`) do not inherit
    variables in `/etc/set-environment`. System-level systemd services run in
    isolated execution environments controlled directly by PID 1 (systemd).
    They do not load interactive shell profiles or login session environments
    for security and predictability reasons. If you need to set environment
    variables for those, check the NixOs options
    `systemd.services.<myservice>.environment` `systemd.globalEnvironment`.
*/
