self: super:
let
  nixos-206-pinned = import (builtins.fetchTarball {
    name = "nixos-20.06";
    url = "https://github.com/nixos/nixpkgs/archive/v206.tar.gz";
    sha256 = "19yihq2n3i7a247a85li46qn17jifds621hkg4mghm1j5jr644lf";
  });
in
{
  poetry = self.callPackage nixos-206-pinned.poetry { };
}
