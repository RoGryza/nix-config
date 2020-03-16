{ config, pkgs, ... }:
let
  inherit (pkgs.vimUtils) buildVimPluginFrom2Nix;
  vimDracula = buildVimPluginFrom2Nix {
    name = "vim-dracula";
    src = pkgs.fetchFromGitHub {
      owner = "dracula";
      repo = "vim";
      rev = "master";
      sha256 = "0b23r37az36kzlzr3k483r1yy142nmz09hc9wkwchs2zns30bqky";
    };
  };
  neovim-qt = pkgs.neovim-qt.override { neovim = config.programs.neovim.finalPackage; };
in
{
  home.packages = with pkgs; [
    neovim-qt
  ];

  programs.neovim = {
    vimAlias = true;
    configure = {
      customRC = ''
        function! MyInit()
          colorscheme dracula
        endfunction

        ${builtins.readFile ./init.vim}
      '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [ ctrlp direnv-vim fugitive vimDracula ];
      };
    };
  };
}
