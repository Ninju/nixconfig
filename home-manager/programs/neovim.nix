{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    vimAlias = true;
    viAlias = true;

    defaultEditor = true;

    extraConfig = builtins.readFile ../../partial_dotfiles/vimrc;

    plugins = with pkgs.vimPlugins; [
      ctrlp
      bufexplorer
      nerdtree
      vim-gitgutter
      tagbar
      colors-solarized
      vim-fireplace
      vim-salve
      vim-visual-increment
      vim-go
      vim-nix
    ];

  };
}
