{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware";

  inputs.uswitch-nixpkgs.url = "git+ssh://git@github.com/uswitch/nixpkgs";

  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.kmonad.url = "github:kmonad/kmonad?dir=nix";

  inputs.dmenu-scripts.url = "gitlab:Ninju1/dmscripts";

  # I have not checked these wallpapers to make sure there is not anything "controversial", etc.
  # Hopefully all backgrounds in the repo are safe-for-work
  inputs.dtos-backgrounds.url = "gitlab:dwt1/wallpapers";
  inputs.dtos-backgrounds.flake = false;

  inputs.i3-layouts.url = "github:eliep/i3-layouts";
  inputs.i3-layouts.flake = false;

  inputs.i3-workspace-groups.url = "github:infokiller/i3-workspace-groups";
  inputs.i3-workspace-groups.flake = false;

  inputs.i3blocks-contrib.url = "github:vivien/i3blocks-contrib";
  inputs.i3blocks-contrib.flake = false;

  inputs.mach-nix.url = "github:DavHau/mach-nix";

  inputs.kitty-themes.url = "github:dexpota/kitty-themes";
  inputs.kitty-themes.flake = false;

  inputs.doom-emacs.url = "github:doomemacs/doomemacs";
  inputs.doom-emacs.flake = false;

# Pin nixpkgs to the version used to build the system
# nix.registry.nixpkgs.flake = nixpkgs;

outputs = {
  self
 , nixpkgs
 , nixos-hardware
 , uswitch-nixpkgs
 , home-manager
 , kmonad
 , dmenu-scripts
 , dtos-backgrounds
 , i3-layouts
 , i3-workspace-groups
 , i3blocks-contrib
 , mach-nix
 , kitty-themes
 , doom-emacs
}@inputs:

let
  i3-overlays = import ./overlays/i3-overlays.nix
    {
      inherit (mach-nix.lib.${system}) buildPythonPackage;
      inherit i3-workspace-groups i3-layouts;
    };

  x86_64-linux-overlays = import ./overlays/x86_64-linux-overlays.nix {};

  system = "x86_64-linux";
  pkgs = import nixpkgs { inherit system;
                          overlays = [
                            (final: prev: dmenu-scripts.packages.${system})
                            (final: prev: uswitch-nixpkgs.packages.${system})
                            i3-overlays.overlay
                            x86_64-linux-overlays.overlay
                          ];

                          config.allowUnfree = true;
                        };

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
        inherit pkgs;

        # Passed into modules as 'specialArgs'
        extraSpecialArgs = {
          inherit
            dtos-backgrounds
            kitty-themes
            doom-emacs
            i3blocks-contrib;
        };

        modules = [
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

    nixosConfigurations.aw-t490 = mkNixosSystem {
      extraModules = [
        nixos-hardware.nixosModules.lenovo-thinkpad-t490
        ./nixos-configuration/aw-t490/configuration.nix
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
