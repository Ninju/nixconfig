{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    vimAlias = true;
    viAlias = true;

    defaultEditor = true;

    extraConfig = builtins.readFile ./config_files/vimrc; 

    plugins = with pkgs.vimPlugins; [
      bufexplorer
      ctrlp
      vim-fireplace
      bufexplorer
      vim-surround
      nerdtree
      vim-gitgutter
      tagbar
      colors-solarized
      vim-surround
      vim-fireplace
      vim-salve
      nerdtree
      vim-gitgutter
      vim-visual-increment
      tagbar
      vim-go
      vim-nix
    ];

  };
}
