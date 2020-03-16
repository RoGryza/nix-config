{ pkgs ? import <nixpkgs> { }, ... }:
{
  boot.kernelPackages = let
    linuxZenPkg = { fetchurl, buildLinux, ...}@args:
      buildLinux (args // rec {
        version = "5.5.9-lqx1";
        modDirVersion = version;

        src = fetchurl {
          url = "https://github.com/zen-kernel/zen-kernel/archive/v${version}.tar.gz";
          sha256 = "12s36plwqhva3hnzpn9di0a6y4ibhzpbsihrrym79psrybg32cwz";
        };
        kernelPatches = [];

        extraMeta.branch = "5.5";
      } // (args.argsOverride or { }));
    linuxZen = pkgs.callPackage linuxZenPkg { };
  in
    pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linuxZen);
}
