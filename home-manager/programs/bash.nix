{ pkgs, ... }:
{
  programs.bash = {
    enable = true;
    sessionVariables = {
      DOTFILES_DIR = "/home/alex/src/git/Ninju/nixconfig";
      DOTFILES_REMOTE_SSH = "git@github.com:Ninju/nixconfig";
      DOTFILES_REMOTE_HTTPS = "https://www.github.com/Ninju/nixconfig";
    };

    shellAliases = {
      ll = "ls -l";
      ".." = "cd ..";
    };
  };
}
