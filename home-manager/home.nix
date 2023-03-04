{ pkgs, config, ... }:
let
  customPackages = pkgs.callPackage ./packages {};
in
{
  home.username = "alex";
  home.homeDirectory = "/home/{home.username}";
  home.stateVersion = "22.11"; # To figure this out you can comment out the line and see what version it expected.
  programs.home-manager.enable = true;

  home.file.".config/i3/config".source = config.lib.file.mkOutOfStoreSymlink ./config_files/i3config;

  # https://nix.dev/anti-patterns/language#with-attrset-expression
  home.packages = builtins.attrValues {
    inherit (pkgs)
    bat
    silver-searcher
    tree
    wget
    htop
    jq
    yq
    csvkit
    feh
    fzf
    ; } ++ [
      customPackages.dm-man
    ];

  programs.git.userEmail = "alex.watt@rvu.co.uk";

  imports = [
    ./programs/neovim.nix
    ./programs/git.nix
    ./programs/kitty.nix
    ./programs/doom_emacs.nix
  ];
}
