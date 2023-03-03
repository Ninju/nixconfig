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

      displayManager = {
        defaultSession = "none+xmonad";
        lightdm = {
          greeters.enso = {
            enable = true;
            blur = true;
          };
        };
      };
    };

    environment.systemPackages = [
      pkgs.dmenu
      pkgs.qutebrowser
      pkgs.conky
      pkgs.xdotool
      pkgs.moc
    ];
  };
}
