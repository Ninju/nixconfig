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
  home.file.".kitty-themes".source = "${specialArgs.kitty-themes}";

  services.lorri.enable = true;

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

      direnv

      feh
      fzf
      htop
      jq
      silver-searcher
      tree
      wget
      yq

      ranger
      sbcl

      u
      kubectl

      xpad
    ; };

  programs.git.userEmail = "alex.watt@rvu.co.uk";

  services.dunst.enable = true;

  services.dunst.settings = {
    global = {
      width = 300;
      height = 300;
      offset = "20x40";
      origin = "top-right";
      transparency = 30;
      frame_color = "#eceff1";
      background = "#24283b";
      foreground = "#c0caf5";
      highlight = "#292e42";
      font = "JetBrainsMono Nerd 9";
    };
  };

  imports = [
    ./programs/bash.nix
    ./programs/chromium.nix
    ./programs/doom_emacs.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/kitty.nix
    ./programs/neovim.nix
    ./programs/gxkb.nix

    ./i3.nix
  ];
}
