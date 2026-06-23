# We use the home-manager foot module to produce the config file because
# foot does not accept an env variable as part of the path to include.
# You don't need to rebuild to apply a new theme but you do if you want
# to change the font size or any of the other configs set by this file.
{
  user,
  currentThemePath,
  ...
}:
{
  home-manager.users.${user} = {
    # Fast, lightweight and minimalistic Wayland terminal emulator
    programs.foot = {
      enable = true;
      settings = {
        main = {
          include = "${currentThemePath}/foot.ini";
          term = "xterm-256color";
          font = "monospace:size=9";
          pad = "14x14";
          initial-window-mode = "windowed";
          workers = "0";
        };
        scrollback = {
          lines = "10000";
        };
        cursor = {
          style = "block";
          blink = "no";
        };
        key-bindings = {
          clipboard-copy = "Control+Insert";
          primary-paste = "none";
          clipboard-paste = "Control+Shift+v";
        };
      };
    };
  };
}
