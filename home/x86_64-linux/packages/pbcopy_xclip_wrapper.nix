{ writeShellScriptBin, xclip, ... }:
writeShellScriptBin "pbcopy" ''
   ${xclip}/bin/xclip -selection clipboard
''
