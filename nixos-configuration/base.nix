{ nixpkgs, kmonad, system, ... }:

{ extraModules, ... }:
nixpkgs.lib.nixosSystem {
  inherit system;

  modules = [
    kmonad.nixosModules.default
    ./configuration.nix
  ] ++ extraModules;
}
