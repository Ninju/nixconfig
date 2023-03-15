{ pkgs, ... }:
let
  pbcopy = import ./packages/pbcopy_xclip_wrapper.nix {
    inherit (pkgs) xclip writeShellScriptBin;
  };
in
{
  services.autorandr.enable = true;

  home.packages = [
    pkgs.xclip
    pbcopy

    pkgs.xorg.xev
    pkgs.autorandr
  ];
}
