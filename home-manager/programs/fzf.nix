{ config, lib, pkgs, ... }:

{
  programs.fzf = {
    enable = true;

    defaultOptions = [
      "--height 90%"
      "--min-height 10"
      "--reverse"
      "--preview-window=down:75%"
    ];

    changeDirWidgetCommand = "find ${config.home.homeDirectory} -maxdepth 4 -type d";
    changeDirWidgetOptions = [ "--preview 'tree -C {}'" ];

    fileWidgetCommand = "find . -type f";
    fileWidgetOptions = [ "--preview 'bat -n --color=always {}'" ];

    historyWidgetOptions = [ "--sort" ];
  };
}
