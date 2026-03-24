{ lib, user }:
{
  virtualisation.docker.enable = true;

  users.users.${user}.extraGroups = [ "docker" ]; # [1]
}

# [1] If the docker service is enabled in the machine the user needs to be a
# member of the `docker` group to interact with the `docker` daemon (e.g. to
# start and stop container).
