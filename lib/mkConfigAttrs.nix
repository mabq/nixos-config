id:

let
  defaults = {
    inherit id;
    system = "x86_64-linux";
    hostname = "dev";
    user = "mabq";
    firewall = true;
    theme = "tokyonight_night";
    timezone = "America/Guayaquil";
    locale = "en_US.UTF-8";
    pkgsAllowUnfree = false;
    pkgsInsecure = [ ];
  };
in defaults // (import ../system/${id}/config.nix)
