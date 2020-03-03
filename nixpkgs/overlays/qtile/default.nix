self: super:
let
  pkgs = super.pkgs;
  python37Packages = pkgs.python37Packages;
  cairocffi-xcffib = python37Packages.cairocffi.override {
    withXcffib = true;
  };
in

{
  cairocffi = python37Packages.cairocffi.overrideAttrs {
    patchPhase = ''
      # Hardcode cairo library path
      sed -e 's,ffi\.dlopen(,&"${pkgs.cairo}/lib/" + ,' -i cairocffi/__init__.py
    '';
  };

  qtile = python37Packages.buildPythonPackage {
    inherit (super.qtile) meta;

    name = "qtile-${self.qtile.version}";
    version = "0.14.2";

    src = super.fetchFromGitHub {
      owner = "qtile";
      repo = "qtile";
      rev = "v${self.qtile.version}";
      sha256 = "1jmb5kdaiir6baw4z2sb4hifpli75r4im8a3mqy226am4z2lyf96";
    };

    patches = [ ./qtile.patch ];

    postPatch = ''
      substituteInPlace libqtile/core/manager.py --subst-var-by out $out
      substituteInPlace libqtile/core/xcursors.py --subst-var-by xcb-cursor ${pkgs.xorg.libxcb}
      substituteInPlace libqtile/pangocffi.py --subst-var-by glib ${pkgs.glib.out}
      substituteInPlace libqtile/pangocffi.py --subst-var-by pango ${pkgs.pango.out}
    '';

    buildInputs = [ pkgs.pkgconfig pkgs.glib pkgs.xorg.libxcb pkgs.cairo pkgs.pango python37Packages.xcffib ];

    pythonPath = with python37Packages; [
      cffi xcffib cairocffi-xcffib setuptools
      psutil pyxdg pydbus mpd2 dateutil keyring # iwlib
    ];
    doCheck = false;

    postInstall = ''
      wrapProgram $out/bin/qtile \
        --set QTILE_WRAPPER '"$0"' \
        --set QTILE_SAVED_PYTHONPATH '"$PYTHONPATH"' \
        --set QTILE_SAVED_PATH '"$PATH"'
    '';
  };
}
