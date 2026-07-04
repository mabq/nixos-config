{ user, ... }:
{
  home-manager.users.${user} =
    { ... }:
    {
      qt = {
        enable = true;
        platformTheme.name = "gtk"; # Qt apps inherit GTK's dark theme/colors directly
        style.name = "adwaita-dark";
      };
    };
}
