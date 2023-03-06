{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware";

  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.kmonad.url = "github:kmonad/kmonad?dir=nix";
  inputs.nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";

# Pin nixpkgs to the version used to build the system
# nix.registry.nixpkgs.flake = nixpkgs;

outputs = { self, nixpkgs, nixos-hardware, home-manager, kmonad, nix-doom-emacs }@inputs:
let
  system = "x86_64-linux";
  pkgs = import nixpkgs { inherit system; };

  nixosSystemBase = import ./nixos-configuration/base.nix { inherit (inputs) nixpkgs kmonad; inherit system; };

  homeManagerInit = (pkgs.writeScriptBin "init-home-manager"
  ''
    nix build .#homeConfigurations.alex.activationPackage
    echo "Don't forget to run " 
    echo         './result/activate'
    echo 
    echo "From now on"
    echo         "home-manager switch --flake ${builtins.toString ./.}"
  '');
in
  {
    homeConfigurations = {
      "alex" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};

        # Passed into modules as 'specialArgs'
        extraSpecialArgs = {};

        modules = [
          nix-doom-emacs.hmModule
          ./home-manager/home.nix
          ./home-manager/${system}/home.nix
        ];
      };
    };

    nixosConfigurations.aw-rvu-x1c5 = nixosSystemBase {
      extraModules = [
        ./nixos-configuration/x1_carbon_5/configuration.nix
      ];
    };

    nixosConfigurations.aw-rvu-x1c10 = nixpkgs.lib.nixosSystem {
      extraModules = [
        nixos-hardware.nixosModules.lenovo-thinkpad-x1-10th-gen
      ];
    };

    devShells.${system}.default = pkgs.mkShell {
      name = "nixconfig-bootstrap";
      packages = [
        pkgs.git
        pkgs.neovim
        homeManagerInit
      ];
    };
  };
}
