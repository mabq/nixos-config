# README

Keyd is a system service, therefore it must be set by a NixOS module - see `/modules/keyd`.

Configuration is applied based on keyboard id - each keyboard must be targeted by a single config file.

The `default.conf` file acts as a safe global fallback for any keyboard which Id is not explicitly typed in any other file.

Use the following commands:

  - `sudo keyd monitor` - show keyboard Ids and keystrokes.
  - `sudo keyd reload` - update changes on config files.
  - `sudo systemd enable/start keyd.service` - enable/start the service.
  - `sudo journalctl -eu keyd` - check for errors.

Please note that:

  - Inline comments are not supported!
  - Included files must NOT contain a `[ids]` section, include other files (inclusion is non-recursive) or have the `.conf` extension.


