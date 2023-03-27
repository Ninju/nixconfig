{ pkgs, config, specialArgs, ... }:
# "Heavily inspired" by https://github.com/hlissner/dotfiles/blob/8fe1fbb6e7fc0d2f95fe75cdb9df7eb0595a0047/modules/editors/emacs.nix
let
  doomRev = specialArgs.doom-emacs.rev;
in
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
  };

  services.emacs.enable = true;

  # IMPORTANT! Assumes that this repo has been symlinked or cloned to ~/.nixconfig
  home.activation.linkDoomEmacs = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    echo "(Sym)Linking .doom.d config"
    $DRY_RUN_CMD ln -sf $HOME/src/git/Ninju/nixconfig/dotfiles/.doom.d $HOME/.doom.d
  '';

  home.activation.installDoomEmacs = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d ~/.config/emacs ]; then
      echo "Installing DOOM Emacs into ~/.config/emacs; run 'doom install' later"

      $DRY_RUN_CMD ${pkgs.git}/bin/git clone http://github.com/doomemacs/doomemacs ~/.config/emacs
      $DRY_RUN_CMD pushd ~/.config/emacs
      $DRY_RUN_CMD ${pkgs.git}/bin/git reset --hard ${doomRev}
      $DRY_RUN_CMD popd

    else
      echo "DOOM Emacs install already detected (rev: ${doomRev}). Delete ~/.config/emacs to start from scratch."
    fi

    echo "DOOM Emacs is installed in ~/.config/emacs and ~/.config/emacs/bin is in the PATH. Check ${../../docs/home-manager/activation_scripts.md} for further instructions and troubleshooting."
  '';

  home.sessionPath = [
    "~/.config/emacs/bin"
  ];

  home.packages = with pkgs; [
    ## Emacs itself
    # binutils       # native-comp needs 'as', provided by this

    # Fonts
    emacs-all-the-icons-fonts

    ## Doom dependencies
    git
    (ripgrep.override {withPCRE2 = true;})
    gnutls              # for TLS connectivity

    ## Optional dependencies
    fd                  # faster projectile indexing
    imagemagick         # for image-dired
    pinentry_emacs      # in-emacs gnupg prompts
    zstd                # for undo-fu-session/undo-tree compression

    ## Module dependencies
    # :checkers spell
    (aspellWithDicts (ds: with ds; [
      en en-computers en-science
    ]))

    # :checkers grammar
    languagetool

    # :tools editorconfig
    editorconfig-core-c # per-project style config

    # :tools lookup & :lang org +roam
    sqlite

    # :lang cc
    ccls

    # :lang javascript
    nodePackages.javascript-typescript-langserver

    # :lang latex & :lang org (latex previews)
    texlive.combined.scheme-medium

    # :lang nix
    nixfmt

    # :lang web
    html-tidy

    # :tools direnv
    direnv

    tabnine
  ];
}
