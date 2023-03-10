{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware";

  inputs.uswitch-nixpkgs.url = "git+ssh://git@github.com/Ninju/uswitch-nixpkgs?ref=aw-flakify-and-add-aws-vpn-client";

  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.kmonad.url = "github:kmonad/kmonad?dir=nix";
  inputs.nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";

  inputs.dmenu-scripts.url = "gitlab:Ninju1/dmscripts";

  # I have not checked these wallpapers to make sure there is not anything "controversial", etc.
  # Hopefully all backgrounds in the repo are safe-for-work
  inputs.dtos-backgrounds.url = "gitlab:dwt1/wallpapers";
  inputs.dtos-backgrounds.flake = false;

# Pin nixpkgs to the version used to build the system
# nix.registry.nixpkgs.flake = nixpkgs;

outputs = { self, nixpkgs, nixos-hardware, uswitch-nixpkgs, home-manager, kmonad, nix-doom-emacs, dmenu-scripts, dtos-backgrounds }@inputs:
let
  system = "x86_64-linux";
  pkgs = import nixpkgs { inherit system; };

  mkNixosSystem = import ./lib/mkNixosSystem.nix {
    inherit (inputs) nixpkgs kmonad;
    inherit system;
    commonConfiguration = ./nixos-configuration/configuration.nix;
  };

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
        extraSpecialArgs = { inherit dtos-backgrounds; };

        modules = [
          { nixpkgs.overlays = [ (self: super: dmenu-scripts.packages.${system})
                                 (self: super: uswitch-nixpkgs.packages.${system})
                               ]; }
          nix-doom-emacs.hmModule
          ./home-manager/home.nix
          ./home-manager/${system}/home.nix
        ];
      };
    };

    nixosConfigurations.aw-rvu-x1c5 = mkNixosSystem {
      extraModules = [
        uswitch-nixpkgs.awsvpnclient
        ./nixos-configuration/aw-rvu-x1c5/configuration.nix
      ];
    };

    nixosConfigurations.aw-rvu-x1c10 = mkNixosSystem {
      extraModules = [
        uswitch-nixpkgs.awsvpnclient
        nixos-hardware.nixosModules.lenovo-thinkpad-x1-10th-gen
        ./nixos-configuration/aw-rvu-x1c10/configuration.nix
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
