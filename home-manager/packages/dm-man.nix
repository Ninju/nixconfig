{ pkgs, ... }:
pkgs.writeShellScriptBin "dm-man" ''
  DMENU="${pkgs.dmenu}/bin/dmenu -i -l 20 -p" DMTERM="${pkgs.kitty}/bin/kitty" ${pkgs.bash}/bin/bash ${./dmscripts/dm-man.sh};
''
