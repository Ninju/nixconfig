{ config, lib, pkgs, ... }:

let
  cfg = config.services.xserver.windowManager.i3;

  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    environment.pathsToLink = [ "/libexec" ];

    services.xserver.windowManager.i3 = {
      extraPackages = with pkgs; [
        i3-gaps
        i3status
        i3blocks
        lxappearance
      ];
    };

    environment.systemPackages = [
      # GUI to manage X screens
      pkgs.arandr
    ];
  };
}
