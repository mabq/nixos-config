Inline comments are not supported!!!

Each keyboard id must only appear in one file.

Included files must NOT use the `.conf` extension, contain a `[ids]` section or
include other files (inclusion is non-recursive).

Use the following commands:

 - `sudo keyd monitor` - to show keyboard ids and keystrokes
 - `sudo keyd reload` - to reload changes from config files
 - `sudo systemd enable/start keyd.service` - to enable/start the service
 - `sudo journalctl -eu keyd` - to check for errors
