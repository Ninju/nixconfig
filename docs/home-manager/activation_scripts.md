# Activation Scripts instructions

## DOOM Emacs

DOOM Emacs is installed in two parts:

1) Emacs is installed using nix
2) DOOM Emacs is installed via the command line utility (`doom install`)

Unfortunately, this means the full Emacs/DOOM setup is split across nix and impure actions.

This means:

1) Running `home-manager switch ...`
2) Running `doom install` for fresh installs

The activation script clones the (DOOM Emacs repo)[https://github.com/doomemacs/doomemacs] to `~/.config/emacs` and adds `~/.config/emacs/bin` to the `$PATH` (which is where `doom` is located). This is subject to change and the code should be checked for up to date behaviour.

Installing Emacs via Home Manager and then running `doom install` should just work. 

_NOTE: Home Manager is also used to link `./.doom.d` out of the `/nix/store` by using hardcoded paths; also via activation scripts._

### PROBLEM: Activation script did not complete successfully

SOLUTION: Delete the directory where DOOM was cloned (`rm -rf ~/.config/emacs`) so next time you are starting fresh.

### PROBLEM: `doom install` worked but Emacs is running a base/empty config

CONTEXT: When I hit this issue, `~/.emacs.d` was empty.

SOLUTION: `rm -rf ~/.emacs.d; emacs` - Deleting the directoring and loading Emacs solved it.

### Why not use the activation script for the install?

When `doom install` is used within an activation script, `straight.el` (DOOM's package manager) fails to install one of the packages. I'm sure this is solvable, but it does not seem worth the trouble given the subsequent workflow will be to use the `doom` CLI directly, instead of `home-manager`/nix to manage dependencies/config/etc.
