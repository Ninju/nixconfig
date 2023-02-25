{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.kmonad.url = "github:kmonad/kmonad?dir=nix";

# Pin nixpkgs to the version used to build the system
# nix.registry.nixpkgs.flake = nixpkgs;

outputs = { self, nixpkgs, home-manager, kmonad }@inputs:
let
  system = "x86_64-linux";
  pkgs = import nixpkgs { inherit system; };

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
        modules = [
          ./home-manager/home.nix
          ./home-manager/${system}/home.nix
        ];
      };
    };

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        inputs.kmonad.nixosModules.default
        ./nixos-configuration/kmonad.nix
        ./nixos-configuration/configuration.nix
        ./nixos-configuration/x1_carbon_5/configuration.nix
      ];
    };

    devShells.${system}.default = pkgs.mkShell {
      name = "nixos-user-env-bootstrap";
      packages = [
        pkgs.git
        pkgs.neovim
        homeManagerInit
      ];

    };

  };
}
