{ pkgs, ... }:
let
  neovim = pkgs.neovim.override {
    configure = {
      customRC = builtins.readFile ./init.vim;
    };
  };
  neovim-qt = pkgs.neovim-qt.override { inherit neovim; };
in
{
  home.packages = [
    neovim
    neovim-qt
  ];
}
