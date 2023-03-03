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
        i3lock
        i3blocks
        rofi
        lxappearance
      ];
    };

    environment.systemPackages = [
    ];
  };
}
