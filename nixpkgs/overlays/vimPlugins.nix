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
in
{
  vimPlugins = super.vimPlugins // {
    inherit vim-dracula;
  };
}
