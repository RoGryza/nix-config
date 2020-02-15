with import <nixpkgs> {};
let
  source = pkgs.lib.sourceByRegex ./. [
    "xmonad.hs" "rogryza-xmonad.cabal"
  ];
in pkgs.haskellPackages.callCabal2nix "rogryza-xmonad" source { }
