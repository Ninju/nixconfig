{pkgs, ...}: {
  home.username = "alex";
  home.homeDirectory = "/home/{home.username}";
  home.stateVersion = "22.11"; # To figure this out you can comment out the line and see what version it expected.
  programs.home-manager.enable = true;

  home.sessionVariables = {
    NIX_CONFIG_PATH = "~/.config/nixconfig";
  };

  home.packages = [
    pkgs.bat
    pkgs.tree
    pkgs.wget
    pkgs.xclip
  ];

  imports = [
    ./programs/neovim.nix
    ./programs/git.nix
    ./programs/kitty.nix
  ];
}
