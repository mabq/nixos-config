{
  user,
  repoPath,
  forceFiles,
  ...
}:
{
  home-manager.users.${user} =
    { pkgs, config, ... }:
    let
      mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      home = {
        packages = with pkgs; [
          foot # Fast, lightweight and minimalistic Wayland terminal emulator
        ];

        file = forceFiles {
          ".config/foot/foot.ini".source = mkOutOfStoreSymlink "${repoPath}/config/foot.ini";
        };
      };
    };
}
