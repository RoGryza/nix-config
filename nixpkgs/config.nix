{
  allowUnfree = true;

  packageOverrides = pkgs: with pkgs; {
    rogryza-xmonad = import ./modules/xmonad;

    screenshot = stdenv.mkDerivation rec {
      name = "screenshot";
      unpackPhase= "true";

      buildInputs = [ scrot xclip ];

      bin = writeScript "screenshot.sh" ''
      #!${bash}/bin/bash
      ${scrot}/bin/scrot -fs
      '';

      desktopItem = makeDesktopItem {
        name = "Screenshot";
        exec = "${bin}";
        comment = "Screenshot a selection to the clipboard";
        desktopName = "Screenshot";
        genericName = "Screenshot";
        categories = "Application;";
      };

      installPhase = ''
        mkdir -p $out/share
        ln -s "${desktopItem}/share/applications" $out/share
      '';
    };
  };
}
