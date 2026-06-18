# README

Keyd is a system service (must be set with a NixOS module).

Only include the module in configurations where you want to use keyd.

## Configuration files
----------------------

Config files (`.conf` extension) target keyboard IDs (not users or machines):

  - Put the keyboard ID under the `[ids]` section of the configuration file you want that keyboard to use.
  - Or do not put it anywhere to use the default configuration (`default.conf`).
  - Make sure each keyboard ID only matches a single config file.

Important:

  - Inline comments are not supported!
  - Included files must NOT use the `.conf` extension, contain a `[ids]` section or include other files (inclusion is non-recursive).

## Commands
-----------

`sudo keyd monitor` - show keyboard Ids and keystrokes.

`sudo keyd reload` - update changes on config files.

`sudo systemd enable/start keyd.service` - enable/start the service.

`sudo journalctl -eu keyd` - check for errors.
