{ pkgs, config, lib, specialArgs, ... }:
let
  username = "alex";
in
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "22.11"; # To figure this out you can comment out the line and see what version it expected.
  programs.home-manager.enable = true;

  home.file.".dtos-backgrounds".source = "${specialArgs.dtos-backgrounds}";

  # https://nix.dev/anti-patterns/language#with-attrset-expression
  home.packages = builtins.attrValues {
    inherit (pkgs)
      bat
      csvkit

      dm-colpick
      dm-ip
      dm-kill
      dm-man
      dm-translate
      dm-websearch
      dm-wifi

      feh
      fzf
      htop
      jq
      silver-searcher
      tree
      wget
      yq

      u
      kubectl
    ; };

  programs.git.userEmail = "alex.watt@rvu.co.uk";

  services.dunst.enable = true;

  imports = [
    ./programs/neovim.nix
    ./programs/bash.nix
    ./programs/git.nix
    ./programs/kitty.nix
    ./programs/doom_emacs.nix

    ./i3.nix
  ];
}
