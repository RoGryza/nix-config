{ config, lib, pkgs, ... }:
with lib;
{
  options = {
    programs.st.enable = mkEnableOption "enable";
    programs.slock.enable = mkEnableOption "enable";
    programs.pass.enable = mkEnableOption "enable";

    xsession.cmds = {
      browser = mkOption { type = types.str; };
      terminal = mkOption { type = types.str; };
      lock = mkOption {
        type = types.str;
        default = config.services.screen-locker.lockCmd;
      };
      run = mkOption { type = types.str; };
      pass = mkOption { type = types.str; };
      editor = mkOption { type = types.str; };
    };
  };

  imports = [
    (mkIf config.programs.firefox.enable {
      xsession.cmds.browser = "${pkgs.firefox}/bin/firefox";
    })
    (mkIf config.programs.pass.enable {
      home.packages = [pkgs.pass];
      xsession.cmds.pass = "${pkgs.pass}/bin/passmenu";
    })
    (mkIf config.programs.st.enable {
      home.packages = [pkgs.st];
      xsession.cmds.terminal = "${pkgs.st}/bin/st";
    })
    (mkIf config.programs.slock.enable {
      services.screen-locker.lockCmd = "/run/wrapper/bin/slock";
    })
    (mkIf config.programs.rofi.enable {
      xsession.cmds.run = "${pkgs.rofi}/bin/rofi -modi drun -show drun";
    })
    (mkIf config.programs.neovim.enable {
      xsession.cmds.editor = "${config.rogryza.neovim.qt.package}/bin/nvim-qt";
    })
  ];
}
