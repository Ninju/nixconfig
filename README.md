# Dotfiles

My dotfiles are managed in [nix](https://nixos.org/).

If you are new to nix, in a nutshell:

* My entire system config can be installed from scratch with a single command: `sudo nixos-rebuild --flake git+https://github.com/Ninju/nixconfig`
* My user config can be installed with `home-manager switch --flake git+https://github.com/Ninju/nixconfig`
* The result is reproducible across machines 
* User-level config (via `home-manager`) works on other Linux distros and on Mac OS if they have the nix package manager installed

## Directory structure
* `./nixos-configuration` - System level config
* `./home-manager` - User level config
* `./pkgs` - Derivations (one per file)
* `./lib` - Libary functions
* `./overlays` - Nixpkgs overlays

You can search inside `./home-manager` for any defined/installed at the user level. And inside `./nixos-configuration` for anything at the system level.
