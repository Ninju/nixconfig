{ pkgs, specialArgs, ... }:
{
  programs.kitty = {
    enable = true;
    # theme = "Aquarium Dark";
    theme = "Tokyo Night";
    extraConfig = builtins.readFile ../../partial_dotfiles/kitty;
  };
}
