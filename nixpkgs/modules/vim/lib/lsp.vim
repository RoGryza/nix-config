{ config, lib, pkgs, ... }:
with lib;
{
  options.rogryza.neovim.lsp.enable = mkEnableOption "enable";
  config = mkIf config.rogryza.neovim.lsp.enable {
    rogryza.neovim.customRC = ''
      function! s:on_lsp_buffer_enabled() abort
          setlocal omnifunc=lsp#complete
          setlocal signcolumn=yes
      endfunction

      augroup lsp_install
          au!
          " call s:on_lsp_buffer_enabled only for languages that has the server registered.
          autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
      augroup end
    '';

    programs.neovim.configure = {
      packages.myLspPackage = with pkgs.vimPlugins; {
        start = [vim-lsp];
        opt = [];
      };
    };
  };
}
