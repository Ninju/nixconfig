{ pkgs, xclip, ... }:
pkgs.writeShellScriptBin "pbcopy" ''
   ${xclip}/bin/xclip -selection clipboard
''
