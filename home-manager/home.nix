{ pkgs, config, lib, specialArgs, ... }:
let
  username = "alex";
in
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.05"; # To figure this out you can comment out the line and see what version it expected.
  programs.home-manager.enable = true;

  home.file.".dtos-backgrounds".source = "${specialArgs.dtos-backgrounds}";
  home.file.".kitty-themes".source = "${specialArgs.kitty-themes}";

  services.lorri.enable = true;
  programs.direnv.enable = true;

  # https://nix.dev/anti-patterns/language#with-attrset-expression
  home.packages = builtins.attrValues {
    inherit (pkgs)
      bat
      csvkit

      docker-compose

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

      pgcli
      postgresql

      ranger
      sbcl

      google-chrome

      u
      kubectl

      inkscape

      pandoc
      cue
      unzip

      xpad
    ; };

  programs.git.userEmail = "alex.watt@rvu.co.uk";

  services.dunst.enable = true;

  services.dunst.settings = rec {
    global = {
      transparency = 30;
      width = 300;
      height = 300;
      offset = "20x40";
      highlight = "#292e42";
      font = "JetBrainsMono Nerd 9";
    };

    urgency_normal = {
      origin = "top-right";
      foreground = "#c0caf5";
      background = "#24283b";
      frame_color = "#eceff1";
    };

    urgency_critical = {
      transparency = 0;
      background = "#990000";
      frame_color = "#ffffff";
      origin = "top-center";
      foreground = "#f0f0f0";
    };

    urgency_low = {
      origin = "top-right";
      foreground = "#c0caf5";
      background = "#24283b";
      frame_color = "#eceff1";
      font = "JetBrainsMono Nerd 8";
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
