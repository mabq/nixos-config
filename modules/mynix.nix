{ user, ... }:
{
  options = {
    mynix =
  };
  config = {
    home-manager.users.${user} =
      { ... }:
      {
        options = { };
        config = {
        };
      };
  };
}
