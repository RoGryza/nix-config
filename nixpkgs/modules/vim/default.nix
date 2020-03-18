{ config, lib, pkgs, ... }:
with lib;
{
  options.rogryza.neovim = {
    customRC = mkOption {
      type = types.lines;
      default = "";
    };

    qt.package = mkOption {
      type = types.package;
      default = pkgs.neovim-qt.override {
        neovim = config.programs.neovim.finalPackage;
      };
    };
  };

  imports = [
    ./lib/nix.vim
    ./lib/lsp.vim
    ./lib/python.vim
  ];

  config = mkIf config.programs.neovim.enable {
    home.packages = [
      config.rogryza.neovim.qt.package
    ];

    programs.neovim = {
      vimAlias = true;
      configure = {
        customRC = ''
          ${builtins.readFile ./init.vim}

          ${config.rogryza.neovim.customRC}

          augroup init
            au!
            autocmd VimEnter * colorscheme dracula
          augroup end
        '';
        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [
            vim-commentary vim-surround
            ctrlp direnv-vim fugitive vim-gitgutter vim-eunuch
            vim-dracula
          ];
        };
      };
    };
  };
}
