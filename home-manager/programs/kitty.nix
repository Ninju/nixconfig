{ pkgs, specialArgs, ... }:
let
  themes = "${specialArgs.kitty-themes}/themes";
in
{
  programs.kitty = {
    enable = true;
    theme = "Aquarium Dark";
    extraConfig = builtins.readFile ./config_files/kitty + ''

    include ${themes}/Github.conf
    '';
  };
}
