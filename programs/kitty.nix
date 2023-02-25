{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    theme = "Aquarium Dark";
    extraConfig = builtins.readFile ./config_files/kitty;
  };
}
