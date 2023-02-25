{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

# Pin nixpkgs to the version used to build the system
# nix.registry.nixpkgs.flake = nixpkgs;

outputs = { self, nixpkgs, home-manager }:
let
  pkgs = import nixpkgs { system = "x86_64-linux"; };

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
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./home.nix ];
      };
    };

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [ ./configuration.nix ];
      };

      devShells.x86_64-linux.default = pkgs.mkShell {
        name = "nixos-user-env-bootstrap";
        packages = [ 
          pkgs.git
          pkgs.neovim
          homeManagerInit
        ]; 

      };

    };
  }
