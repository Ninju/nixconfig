{pkgs, ...}: {
    home.username = "alex";
    home.homeDirectory = "/home/{home.username}";
    home.stateVersion = "22.11"; # To figure this out you can comment out the line and see what version it expected.
    programs.home-manager.enable = true;

    home.sessionVariables = {
	    NIX_CONFIG_PATH = "~/.config/nixconfig";
    };

    home.packages = [
	pkgs.bat
    ];



programs.git = {
    enable = true;
    userName = "Ninju";
    userEmail = "alex.watt@rvu.co.uk";
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
#   signing = {
#     signByDefault = true;
#     key = "************";
#   };

    ignores = ["*.swp" "*~"];
  };
	
}
