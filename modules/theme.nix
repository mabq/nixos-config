{
  user,
  repoPath,
  currentThemePath,
  theme,
  ...
}:
{
  home-manager.users.${user} =
    { pkgs, config, ... }:
    let
      mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
      # `home.file` expects a path relative to the user's home directory, so we
      # need to remove part of the absolute path.
      _currentThemePath = pkgs.lib.removePrefix "/home/${user}" currentThemePath;
    in
    {
      # Theme files (should work by just changing a single symlink).
      home.file."${_currentThemePath}" = {
        source = mkOutOfStoreSymlink "${repoPath}/themes/${theme}";
        force = true;
      };
    };
}
