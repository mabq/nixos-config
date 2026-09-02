{
  pkgs,
  user,
  repoDir,
  ...
}:
{
  home-manager.users.${user} =
    { config, ... }:
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
  Related configurations
  ======================

  - Shell init
    Atuin must be initialized by a shell config file.
      https://docs.atuin.sh/latest/guide/shell-integration/
      https://docs.atuin.sh/latest/configuration/key-binding/

  - User's module
    Overrides the random encryption key created at installation with the one of
    the user's Atuin account.

  Manual steps
  ============

  Must run `atuin login` to login and `atuin sync` to start sync (see notes
  below).

  Encryption key
  ==============

  All devices linked to an Atuin account must use the same encryption key and
  will share the same history. If you need separate histories, create separate
  Atuin accounts.

  Atuin does not read authentication credentials from files, so if you wish to
  sync history you need to manually run `atuin login`.
   https://docs.atuin.sh/latest/guide/sync/#login

  INFO: No longer applies, use the password manager to get the encryption key.
  If you don't have a web-broser on the machine, ssh into it using Tailscale
  from a machine that does, copy the code and paste it in the prompt.

  In order to avoid typing the encryption key manually (which replaces the
  content of `~/.local/share/atuin/key`), we use the user's module to create
  that file from a secret. So, when executing `atuin login` just leave the
  encryption key empty. You need a browser to open the authentication URL.

  Run `atuin key --base64` to check the encryption key. We can safely override
  the key because it is only used for syncing data. The local database is not
  encrypted.

  Links
  =====

  Atuin docs:
    https://docs.atuin.sh/latest/

  Shortcuts:
    https://docs.atuin.sh/latest/configuration/key-binding/#atuin-ui-shortcuts
*/
