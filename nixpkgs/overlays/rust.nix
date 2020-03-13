self:
{ autoPatchelfHook, platforms, stdenv, fetchurl, ... }:
let
  inherit (self.rust-analyzer) version;
in
{
  rust-analyzer = stdenv.mkDerivation {
    name = "rust-analyzer-${version}";
    version = "2020-03-09";
    src = fetchurl {
      url = "https://github.com/rust-analyzer/rust-analyzer/releases/download/${version}/rust-analyzer-linux";
      sha256 = "0kga537fviz2sxawwr8q9khr7kq4yknm5q31llid4sczmn447w5j";
    };

    nativeBuildInputs = [autoPatchelfHook];

    dontConfigure = true;
    dontBuild = true;
    dontUnpack = true;

    installPhase = ''
      install -m755 -D $src $out/bin/rust-analyzer
    '';
  };
}
