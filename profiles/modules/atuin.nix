# Authentication required!
{
  dotfiles ? "default",
}:
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
            source = mkOutOfStoreSymlink "${repoDir}/dotfiles/atuin/${dotfiles}/config.toml";
            force = true;
          };
        };
      };
    };
}

/*
  Notes
  -----

  Atuin must be initialized by the shell, for more info see:
   https://docs.atuin.sh/latest/guide/shell-integration/
   https://docs.atuin.sh/latest/configuration/key-binding/

  This modules enables Atuin and you can start using it right away, but if you
  want to sync history with another machine/s you must execute `atuin login`
  and enter a encryption key.

  Encryption key
  --------------

  To share history with other machines you first need to authenticate (via a
  web browser) and then enter the same encryption key used by those machines.

  Obtain the encryption key:
   - Get it from your passwork manager, or
   - Execute `atuin key [--base64]` in one of the other machines.

  Authenticate and sync:
   - Execute `atuin login` (opens a web browser to authenticate).
   - When prompted, enter the encryption key. If you don't provide one, Atuin
     will use the random key stored in `~/.local/share/atuin/key`.

  If you want to backup your history, but not share it with other machines, you
  need to create a separate account.

  For more information, see:
   https://docs.atuin.sh/latest/guide/sync/#login
*/
