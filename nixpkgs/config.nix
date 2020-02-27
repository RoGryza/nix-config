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
      copy_and_delete='sh -c "xclip -selection clipboard -t image/png -i $f; rm $f"'
      ${scrot}/bin/scrot --silent --select --freeze -e "$copy_and_delete"
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
