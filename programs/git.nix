{ pkgs, cfg, ... }:
{
  programs.git = {
    enable = true;
    userName = "Ninju";
    userEmail = cfg.email;
    aliases = {
      unstage = "reset HEAD --";
      pr = "pull --rebase";
      co = "checkout";
      ci = "commit";
      br = "branch";
      st = "status";
      gong = "commit --amend --no-edit";
      gianf = "push --force-with-lease";
      l = "log --graph --pretty='%Cred%h%Creset - %C(bold blue)<%an>%Creset %s%C(yellow)%d%Creset %Cgreen(%cr)' --abbrev-commit --date=relative";
      lg = "log --graph --pretty='%Cred%h%Creset - %C(bold blue)<%an>%Creset %s%C(yellow)%d%Creset %Cgreen(%cr)' --abbrev-commit --date=relative";
      pp = "!git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)";
      recent-branches = "branch --sort=-committerdate";
      current-branch = "rev-parse --abbrev-ref HEAD";
    };
    extraConfig = {
      core = { editor = "nvim"; };
      rerere.enabled = true;

      # Fixes getting dependencies from private repos in Golang
      url."git@github.com:".insteadOf = "https://github.com/";
    };

    signing = cfg.signing;

    ignores = ["*.swp" "*~" ".bak"];
  };
}
