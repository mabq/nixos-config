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
  Atuin accounts.

  Unfortunatelly, Atuin does not allow me to write auth credentials to a file
  and read from there to automate the login process. So, if you wish to sync
  history you need to manually run `atuin login`.
   https://docs.atuin.sh/latest/guide/sync/#login

  If you are already syncing history in another machine (with the same Atuin
  account), you need to use the same encryption key as the other machine.
  Run `atuin key --base64` to check the encryption key it is using.

  In order to avoid typing the encryption key manually (which under the hood
  replaces the current content of `~/.local/share/atuin/key`), we use the
  user's module to create that file from a secret. So, when executing `atuin
  login` leave the encryption key empty to use the key from the file.

  Note: It is safe to override the key because it is only used when syncing
  data. The local database is not encrypted.

  Initializing
  ============

  `atuin init zsh --disable-up-arrow` is done in the shell `init` file.
    https://docs.atuin.sh/latest/configuration/key-binding/

  Links
  =====

  Atuin docs:
    https://docs.atuin.sh/latest/

  Shortcuts:
    https://docs.atuin.sh/latest/configuration/key-binding/#atuin-ui-shortcuts
*/
