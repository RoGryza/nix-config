{ config, lib, pkgs, ... }:
with lib;
{
  options.services.dropbox.enable = mkEnableOption "enable";

  config = mkIf config.services.dropbox.enable {
    home.packages = [ pkgs.dropbox ];

    xsession.autoStartServices = ["dropbox"];
    systemd.user.services.dropbox = {
      Unit = {
        Description = "Dropbox";
      };

      Service = {
        Restart = "on-failure";
        RestartSec = 1;
        ExecStart = "${pkgs.dropbox}/bin/dropbox";
        Environment = "QT_PLUGIN_PATH=/run/current-system/sw/${pkgs.qt5.qtbase.qtPluginPrefix}";
      };
    };
  };
}
