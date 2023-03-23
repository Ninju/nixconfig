{ config, lib, pkgs, ... }:
{
  home.file.".config/gxkb/gxkb.cfg".source = ../../dotfiles/.config/gxkb/gxkb.cfg;

  home.packages = [
    pkgs.gxkb
  ];

  # TODO: Do <something> about the hidden coupling between i3 start-up commands
  #       and programs such as this...
}
