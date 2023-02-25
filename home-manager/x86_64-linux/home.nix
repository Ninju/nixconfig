{ pkgs, ... }:
let
  pbcopy = import ./packages/pbcopy_xclip_wrapper.nix {
    inherit (pkgs) xclip writeShellScriptBin;
  };
in
{
  home.packages = [
    pkgs.xclip
    pbcopy
  ];
}
