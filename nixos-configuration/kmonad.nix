{ pkgs, lib, config, ... }:
let
  cfg = config.services.kmonad;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    services.kmonad = {
      keyboards = {
        "ThinkpadX1" = {
          name = "ThinkpadX1";
          device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";

          defcfg = {
            # Generate the defcfg
            enable = true;
            fallthrough = true;
            allowCommands = false;
          };

          config = builtins.readFile ./config_files/kmonad.lisp;
        };
      };
    };
  };
}
