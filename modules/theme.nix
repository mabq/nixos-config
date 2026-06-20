{
  user,
  repoPath,
  currentThemePath,
  theme,
  forceFiles,
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
      home.file = forceFiles {
        # Theme files (should work by just changing a single symlink).
        "${_currentThemePath}".source = mkOutOfStoreSymlink "${repoPath}/themes/${theme}";
      };
    };
}
