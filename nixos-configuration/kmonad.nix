{ pkgs, ... }:
{
  services.kmonad = {
    enable = true;
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
}
