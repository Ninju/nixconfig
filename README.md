# Dotfiles

My dotfiles are managed in [nix](https://nixos.org/).

|          |                                                                                                   |
|----------|---------------------------------------------------------------------------------------------------|
| Shell    | [bash](https://www.gnu.org/software/bash/)                                                        |
| DM       | [SDDM](https://github.com/sddm/sddm)                                                              |
| WM       | [i3](https://github.com/doomemacs/doomemacs) + [i3blocks](https://github.com/doomemacs/doomemacs) |
| Editor   | [Doom Emacs](https://github.com/doomemacs/doomemacs)                                              |
| Terminal | [kitty](https://sw.kovidgoyal.net/kitty/)                                                         |
| Launcher | [rofi](https://github.com/davatorium/rofi)                                                        |
| Keyboard | [KMonad](https://github.com/kmonad/kmonad)                                                        |

## Get private Github repos working...

Create a `~/.netrc` with the following config:

``` sh
machine https://github.com
login <github username>
password <token, e.g. ghp_...>
```
