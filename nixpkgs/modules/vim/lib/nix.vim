{ config, lib, pkgs, ... }:
{
  rogryza.neovim.customRC = ''
    augroup nix
      au!
      autocmd FileType nix packadd vim-addon-nix
      autocmd FileType nix setlocal shitfwidth=2 tabstop=2
    augroup end
  '';

  programs.neovim.configure = {
    packages.myNixPackage = with pkgs.vimPlugins; {
      start = [vim-nix];
      opt = [vim-addon-nix];
    };
  };
}
