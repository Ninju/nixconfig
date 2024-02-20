{ config, lib, pkgs, ... }:

{
  services.kmonad = {
    enable = true;
    keyboard = {
        name = "ThinkpadX1_test";
        device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";

        defcfg = {
          # Generate the defcfg
          enable = true;
          fallthrough = true;
          allowCommands = false;
        };

        config = builtins.readFile ../partial_dotfiles/kmonad.kbd;
    };
  };
}
