{
  repoDir,
  themeDir,
}:
{
  environment.sessionVariables = {
    REPODIR = "${repoDir}";
    THEMEDIR = "${themeDir}";

    PATH = "${repoDir}/bin"; # include repo binaries, do not use `:$PATH` here
    PAGER = "less -R --use-color -Dd+r -Du+b";
    MANPAGER = "less -R --use-color -Dd+r -Du+b";
    MANROFFOPT = "-P -c"; # https://wiki.archlinux.org/title/Color_output_in_console#Using_less
    # TERM = # do not set this variable, it is set by each terminal emulator.
  };
}
