{
  user,
  repoDir,
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
          atuin # Replacement for a shell history
        ];

        file = {
          ".config/atuin/config.toml" = {
            source = mkOutOfStoreSymlink "${repoDir}/config/atuin/config.toml";
            force = true;
          };
        };
      };
    };
}

/*
  Encryption key
  ==============

  All devices linked to an Atuin account must use the same encryption key and
  will share the same history. If you need separate histories, create separate
  accounts.

  Unfortunatelly, Atuin does not allow me to write auth credentials to a file
  and read from there to automate the login process. So, if you wish to sync
  history you need to manually run `atuin login`.
   https://docs.atuin.sh/latest/guide/sync/#login

  Notice that if you are already syncing history in another machine (with the
  Atuin account), you need to use the same encryption key used by the other
  machine. Run `atuin key --base64` to check the encryption key it is using.

  In order to avoid typing the encryption key manually (which under the hood
  replaces the current content of `~/.local/share/atuin/key`), we use the
  user's module to override that file from a secret. When executing `atuin
  login` leave the encryption key empty to use the now overriden key.

  Note: It is safe to override the key because it is only used when syncing
  data. The local database is not encrypted.
*/
