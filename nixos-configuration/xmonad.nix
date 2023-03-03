{ config, lib, pkgs, ... }:

let
  cfg = config.services.xserver.windowManager.xmonad;

  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    services.xserver = {
      windowManager.xmonad = {
        enableContribAndExtras = true;
        extraPackages = haskellPackages: [
          haskellPackages.xmobar
        ];

        # then xmonad binary will use ~/.config/xmonad
        # if config option is set to null
        #
        #   config = ./path/to/xmonad.hs # (nullOr (either path str))
      };
    };


    environment.systemPackages = [
      pkgs.xmobar

      # Launcher
      pkgs.dmenu

      # Keyboard-controlled web-browser
      pkgs.qutebrowser

      pkgs.conky

      # Fake input and window management..
      pkgs.xdotool

      # Music on console
      pkgs.moc

      # FFMPEG
      pkgs.ffmpeg_5-full

      # Manage session
      pkgs.lxsession

      # Network Manager (TODO: see dmenu variant!)
      pkgs.networkmanagerapplet

      # Compositing
      pkgs.picom

      # Volume icon
      pkgs.volumeicon
    ];
  };
}
