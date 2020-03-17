{ config, lib, pkgs, ... }:
with lib;
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
  pluginModule = types.submodule {
    options = {
      package = mkOption {
        type = types.package;
      };
      init = mkOption {
        type = types.lines;
        default = "";
      };
    };
  };
in
{
  options.rogryza.neovim = {
    initPlugins = mkOption {
      type = types.listOf pluginModule;
      default = [];
    };

    ftPlugins = mkOption {
      type = types.attrsOf (types.listOf pluginModule);
      default = {};
    };
  };

  config =
    let
      initPlugins = config.rogryza.neovim.initPlugins;
      ftPlugins = config.rogryza.neovim.ftPlugins;
      initScripts = concatMapStrings ({init, ...}: "${init}\n") initPlugins;
      autoCmdScripts = concatMapStringsSep "\n"
        (ft: "")
        (attrNames ftPlugins);
      ftScripts = concatStringsSep "\n" (mapAttrsToList
        (ft: plugins:
          let body = concatMapStrings
            ({package, init, ...}: ''
            packadd ${getName package}
            ${init}
            '')
            plugins;
          in ''
         function! MyAuto${ft}()
           ${body}
         endfunction
         autocmd FileType ${ft} call MyAuto${ft}()
         '')
        ftPlugins);
    in
    {
      home.packages = with pkgs; [
        neovim-qt
      ];

      rogryza.neovim = {
        initPlugins = [
          {
            package = vimDracula;
            init = "colorscheme dracula";
          }
        ];
        ftPlugins.nix = [
          { package = pkgs.vimPlugins.vim-addon-nix; }
        ];
      };

      programs.neovim = {
        vimAlias = true;
        configure = {
          customRC = ''
          function! MyInit()
            ${initScripts}
          endfunction

          ${ftScripts}

          ${builtins.readFile ./init.vim}
        '';
          packages.myVimPackage = with pkgs.vimPlugins; {
            start = [ ctrlp direnv-vim fugitive vim-nix ] ++ map ({package, ...}: package) initPlugins;
            opt = map ({package, ...}: package) (concatLists (attrValues ftPlugins));
          };
        };
      };
    };
}
