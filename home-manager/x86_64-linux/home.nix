{ pkgs, ... }:
let
  pbcopy = import ./packages/pbcopy_xclip_wrapper.nix {
    inherit (pkgs) xclip writeShellScriptBin;
  };
in
{

  programs.chromium = {
    enable = true;
    extensions = [
      "hdokiejnpimakedhajhdlcegeplioahd" # LastPassword
    ];
  };

  home.packages = [
    pkgs.xclip
    pbcopy

    pkgs.xorg.xev
  ];
}
