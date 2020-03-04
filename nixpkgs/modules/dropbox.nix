{ pkgs, ... }:
{
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
}
