{pkgs, config, ... }:
{
  home.username = "alex";
  home.homeDirectory = "/home/{home.username}";
  home.stateVersion = "22.11"; # To figure this out you can comment out the line and see what version it expected.
  programs.home-manager.enable = true;

  home.sessionVariables = {
    NIX_CONFIG_PATH = "~/.config/nixconfig";
  };

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
    ; };

  imports = [
    ./programs/neovim.nix
    ./programs/git.nix
    ./programs/kitty.nix
  ];
}
