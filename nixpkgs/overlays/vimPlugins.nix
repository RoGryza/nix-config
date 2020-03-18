self: super:
let
  inherit (super.pkgs) fetchFromGitHub;
  inherit (super.vimUtils) buildVimPluginFrom2Nix;

  vim-dracula = buildVimPluginFrom2Nix {
    name = "vim-dracula";
    src = fetchFromGitHub {
      owner = "dracula";
      repo = "vim";
      rev = "master";
      sha256 = "0b23r37az36kzlzr3k483r1yy142nmz09hc9wkwchs2zns30bqky";
    };
  };
  async = buildVimPluginFrom2Nix {
    name = "async";
    src = fetchFromGitHub {
      owner = "prabirshrestha";
      repo = "async.vim";
      rev = "master";
      sha256 = "13rf9f345rv86chv5sfbnisq3zkwkfxg903wa1xy1ka1kk6hpr7w";
    };
  };
  vim-lsp = buildVimPluginFrom2Nix {
    name = "vim-lsp";
    dependencies = [self.vimPlugins.async];
    src = fetchFromGitHub {
      owner = "prabirshrestha";
      repo = "vim-lsp";
      rev = "master";
      sha256 = "0yvjvvrlby089l3wi8vsvs3041nvm16sv45rgpr3fjgir3a0iay0";
    };
  };
  vim-lsp-python = buildVimPluginFrom2Nix {
    name = "vim-lsp-python";
    depedencies = [self.vimPlugins.vim-lsp];
    src = fetchFromGitHub {
      owner = "ryanolsox";
      repo = "vim-lsp-python";
      rev = "master";
      sha256 = "1vlmanl9jhklm3brba90bbgl68m6y1fz4f3fw2mqv5ds7nsxwrl9";
    };
  };
in
{
  vimPlugins = super.vimPlugins // {
    inherit vim-dracula async vim-lsp vim-lsp-python;
  };
}
