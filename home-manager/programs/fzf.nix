{ config, lib, pkgs, ... }:

{
  programs.fzf = {
    enable = true;

    defaultOptions = [
      "--height 60%"
      "--reverse"
      "--padding 0,37"
      "--preview-window=down:50%"
    ];

    changeDirWidgetCommand = "find /home/alex/src -maxdepth 3 -type d";
    changeDirWidgetOptions = [ "--preview 'tree -C {}'" ];

    fileWidgetCommand = "find . -type f";
    fileWidgetOptions = [ "--preview 'bat -n --color=always {}'" ];

    historyWidgetOptions = [ "--sort" ];
  };
}
