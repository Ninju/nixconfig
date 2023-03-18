{ config, lib, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.kitty}/bin/kitty";
    cycle = true;
    extraConfig = builtins.readFile ./config_files/rofi.rasi;
  };
}
