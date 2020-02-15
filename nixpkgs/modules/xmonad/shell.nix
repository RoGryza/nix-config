with import <nixpkgs> {};

pkgs.haskellPackages.shellFor {
  packages = p: [
    p.xmonad
    p.xmonad-contrib
    p.xmonad-extras
  ];
}
