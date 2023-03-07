{ nixpkgs, kmonad, system, commonConfiguration, ... }:

{ extraModules, ... }:
nixpkgs.lib.nixosSystem {
  inherit system;

  modules = [
    kmonad.nixosModules.default
    commonConfiguration
  ] ++ extraModules;
}
