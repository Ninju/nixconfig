{ pkgs, ... }:
{
  services.autorandr.enable = true;

  home.packages = [
    pkgs.xclip
    pkgs.pbcopy
    pkgs.xorg.xev
    pkgs.autorandr
  ];
}
