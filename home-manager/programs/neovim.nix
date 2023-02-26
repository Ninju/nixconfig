{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    vimAlias = true;
    viAlias = true;

    defaultEditor = true;

    extraConfig = builtins.readFile ./config_files/vimrc; 

    plugins = with pkgs.vimPlugins; [
      ctrlp
      bufexplorer
      nerdtree
      vim-gitgutter
      tagbar
      colors-solarized
      vim-surround
      vim-fireplace
      vim-salve
      vim-visual-increment
      vim-go
      vim-nix
    ];

  };
}
