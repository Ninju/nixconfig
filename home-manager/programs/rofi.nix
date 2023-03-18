{ config, lib, pkgs, ... }:

{
  home.file.".config/rofi/config.rasi".source = ./config_files/rofi.rasi;

  home.packages = [
    pkgs.rofi
  ];
}
