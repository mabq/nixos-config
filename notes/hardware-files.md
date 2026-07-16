# Hardware files

> IMPORTANT!
  Do not reuse a hardware file!
  Create a new one on every installation (or when a hardware part is replaced)

Hardware files should be named in the following manner:

  `<hardware-model.[instance.]date>.nix`, e.g. `GB-BXi3-5010.1.260713`.

Why?

1. The hardware model will help you identify the machine the file belongs to.

   E.g. `GB-BXi3-5010` (Gigabyte Brix).

2. The instance (optional) will help you identify an instance of the same model.

   Optional because on most cases you will only have one machine of a given model, but will be useful if you need to deploy different configurations to the same instance model in a data center.

   E.g. `1` (First instance).

3. The date allows to quickly identify when the file was created.

   Its important to understand that the same machine will produce different hardware files at different times:

     - A reinstall changes disks UUIDs (formatting) and `system.stateVersion` (if a newer version of NixOs was used).
     - Parts could be replaced (disk, GPU, memory).

    E.g. `260713` (July 13, 2026).
