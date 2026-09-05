{
  configName ? "default",
}:
{
  pkgs,
  user,
  repoConfigDir,
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
            source = mkOutOfStoreSymlink "${repoConfigDir}/atuin/${configName}.toml";
            force = true;
          };
        };
      };
    };
}

/*
  Important!
   Atuin must be initialized by a shell config file:
   https://docs.atuin.sh/latest/guide/shell-integration/
   https://docs.atuin.sh/latest/configuration/key-binding/

  Sync history
  ------------

  This modules enables Atuin and you can start using it right away, but if you
  want to sync history with another machine/s you must execute:

    `atuin login`

  The command will prompt you for a encryption key.

  If you don't want to sync history with other machine/s just press enter.
  Atuin will use a random encryption key stored in
  `~/.local/share/atuin/key`.

  Otherwise, enter the same encryption key used in the other machine/s. You can
  obtain the key from the password manager or by executing the following
  command in one of those machines:

    `atuin key`

  Atuin will replace the content of `~/.local/share/atuin/key` with the entered
  encryption key.

  Then, Atuin will open a web browser for you to authenticate (use your password
  manager). That's it!

  If you want to backup your history in atuin's servers, but not share it with
  other machines, you need to create a separate account.

  For more information, see:
   https://docs.atuin.sh/latest/guide
*/
