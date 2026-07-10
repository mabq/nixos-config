# Nix modules options and config

```nix
# configuration.nix or a shared system module
{ config, pkgs, inputs, ... }: {

  # 1. NixOS System Level Config
  environment.systemPackages = [ pkgs.curl ];
  services.openssh.enable = true;

  # 2. Embedding Home Manager directly into NixOS
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.yourusername = { config, pkgs, ... }: {
    # Home Manager User Level Config
    home.stateVersion = "24.05";
    programs.git.enable = true;

    # You can even reference NixOS options from here using 'osConfig'
    # e.g., osConfig.networking.hostName
  };
}
```

Both NixOS and Home Manager use the exact same underlying Nix module system.

NixOS modules manage the hardware, system-level daemons, and everything required to boot the machine. Home-manager modules manage your dotfiles, user-specific packages, and desktop environment settings.

In a module, `options` and `config` serve different but complementary purposes:

  - `options` declares what configuration settings exist.
  - `config` implements the behavior based on those settings.

Think of `options` as the interface and `config` as the implementation.


## options
----------

The `options` attribute defines configuration options that users can set in their `configuration.nix` or in other modules.

For example:

```nix
{ lib, ... }:
{
  # `mkEnableOption` is sugar syntax for `lib.mkOption`
  options.services.myapp.enable = lib.mkEnableOption "my custom service";
}
```

This creates a new option: `services.myapp.enable`.

The option declaration specifies things like:

  - type
  - default value
  - description
  - examples
  - whether it's read-only
  - merge behavior

A more complete example:

```nix
{
  options.services.myapp.port = lib.mkOption {
    type = lib.types.port;
    default = 8080;
    description = "Port on which MyApp listens.";
  };
}
```

Now users can write:

```nix
{
  services.myapp.port = 9000;
}
```

Without an `options` declaration, NixOS doesn't know that this option exists.


## config
---------

`config` contains the actual configuration that contributes to the final system configuration.

Inside a NixOS module, `config` refers to system-wide settings (like `config.networking`). Inside a Home Manager module, `config` refers to your user settings (like `config.programs.git`).

Typically it uses the options you've declared:

```nix
{ config, lib, ... }:
{
  config = lib.mkIf config.services.myapp.enable {
    systemd.services.myapp = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "/bin/myapp";
    };
  };
}
```

Here, `config.services.myapp.enable` reads the user's value, if it's `true`, additional configuration is added.

So:

```nix
services.myapp.enable = true;
```

results in:

```nix
systemd.services.myapp = { ... };
```

being included in the final system configuration.


## Why they're separated
------------------------

The module system works in two phases:

1. All modules declare their available options.
2. The module system merges all option values and computes the final configuration.

Separating declaration from implementation allows:

- type checking
- automatic documentation
- validation
- merging configuration from many modules
- defaults and priorities (`mkDefault`, `mkForce`, etc.)


## Example module
-----------------

```nix
{ config, lib, pkgs, ... }:

{
  options.services.hello = {
    enable = lib.mkEnableOption "Hello service";

    greeting = lib.mkOption {
      type = lib.types.str;
      default = "Hello";
      description = "Greeting to print.";
    };
  };

  config = lib.mkIf config.services.hello.enable {

    systemd.services.hello = {
      wantedBy = [ "multi-user.target" ];

      serviceConfig.ExecStart =
        "${pkgs.writeShellScript "hello" ''
          echo "${config.services.hello.greeting}"
        ''}";
    };

  };
}
```

A user can enable it with:

```nix
{
  services.hello = {
    enable = true;
    greeting = "Welcome!";
  };
}
```

The `options` section defines what settings are available, while the `config` section reads those settings and generates the appropriate systemd service.


## Can a module omit one of them?
---------------------------------

Yes.

Only `config`:

```nix
{
  config.environment.systemPackages = [ pkgs.git ];
}
```

This module simply contributes configuration without defining any new options.

Only `options`:

```nix
{
  options.myOption = lib.mkOption {
    type = lib.types.int;
  };
}
```

This declares an option but doesn't use it directly. Another module may consume it.


## How config is formed
-------------------------

An important detail is that `config` is **not local to a single module**. It is the merged result of **all** modules in the system.

For example, suppose two modules contribute:

Module A:

```nix
{
  config.networking.hostName = "server";
}
```

Module B:

```nix
{
  config.environment.systemPackages = [ pkgs.git ];
}
```

The final `config` seen by every module is effectively:

```nix
{
  networking.hostName = "server";

  environment.systemPackages = [
    pkgs.git
  ];
}
```

Likewise, if a user sets:

```nix
services.hello.enable = true;
```

that value becomes part of the merged `config`, and any module can read it as:

```nix
config.services.hello.enable
```

This global, lazily evaluated configuration graph is what makes the NixOS module system powerful: modules can declare options independently, contribute pieces of configuration, and reference each other's options **without requiring a fixed evaluation order**.

