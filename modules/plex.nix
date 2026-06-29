{ user, ... }:
{
  services.plex = {
    enable = true;
    openFirewall = true;
  };
}
