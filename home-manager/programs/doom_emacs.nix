{ pkgs, ... }:
{
  programs.doom-emacs = {
    enable = true;

    emacsPackage = pkgs.emacs-gtk;

    doomPrivateDir = ./config_files/.doom.d;
    doomPackageDir = pkgs.linkFarm "my-doom-packages" [
      { name = "config.el"; path = ./config_files/.doom.d/config.el; }
      { name = "init.el"; path = ./config_files/.doom.d/init.el; }
      { name = "packages.el"; path = ./config_files/.doom.d/packages.el; }
    ];

    extraConfig = ''
    (setq deft-directory "~/Documents/__emacs/deft_notes"
          deft-extensions '("org" "txt")
          deft-recursive t)

    '';
  };
}
