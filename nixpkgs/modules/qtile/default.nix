{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.xsession.windowManager.qtile;
in
{
  options.xsession.windowManager = {
    qtile = {
      enable = mkEnableOption "enable";
    };
  };

  config = mkIf cfg.enable {
    xsession.enable = true;
    xsession.windowManager.command = "QTILE_CFG_PATH=${config.xdg.configHome}/qtile/config ${pkgs.qtile}/bin/qtile";

    xdg.configFile.qtile = {
      source = ./config;
      recursive = true;
    };
    xdg.configFile."qtile/config/autostart".text = concatStringsSep "\n" config.xsession.autoStartServices;
  };
}
