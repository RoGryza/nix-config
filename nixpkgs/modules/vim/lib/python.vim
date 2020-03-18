{ config, lib, pkgs, ... }:
{
  rogryza.neovim.lsp.enable = true;
  rogryza.neovim.customRC = ''
    function! MyPython()
      setlocal foldmethod=indent foldlevel=99
      setlocal tabstop=4 softabstop=4 shiftwidth=4 textwidth=99 autoindent fileformat=unix
    endfunction

    augroup python
      au!
      autocmd FileType python call MyPython()
    augroup end
  '';

  programs.neovim.configure = {
    packages.myNixPackage = with pkgs.vimPlugins; {
      start = [
        vim-lsp-python
      ];
      opt = [];
    };
  };
}

