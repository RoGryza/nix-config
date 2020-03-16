{ config, lib, pkgs, ... }:
let
  my-dwm = pkgs.dwm.overrideAttrs (_: {
    postPatch = let
      cmds = with lib; mapAttrs
        (_: cmd: concatMapStringsSep ", " (s: ''"${s}"'') (splitString " " cmd))
        config.xsession.cmds;
    in ''
      substitute ${./config.h} config.h \
        --subst-var-by runcmd '${cmds.run}' \
        --subst-var-by termcmd '${cmds.terminal}' \
        --subst-var-by browsercmd '${cmds.browser}' \
        --subst-var-by lockcmd '${cmds.lock}' \
        --subst-var-by passcmd '${cmds.pass}' \
        --subst-var-by editorcmd '${cmds.editor}'
    '';
  });
in
{
  options.xsession.windowManager.my-dwm = {
    enable = lib.mkEnableOption "enable";
  };

  config = lib.mkIf config.xsession.windowManager.my-dwm.enable {
    home.packages = [my-dwm];
    xsession.windowManager.command = "${my-dwm}/bin/dwm";
  };
}
