{ config, lib, pkgs, ... }:
with lib;
{
  imports = [
    ./qtile
    ./dwm
  ];

  options.xsession = {
    autoStartServices = mkOption {
      type = types.listOf types.str;
      default = [];
    };

    cmds = {
      browser = mkOption {
        type = types.str;
        default = "${pkgs.firefox}/bin/firefox";
      };

      terminal = mkOption {
        type = types.str;
        default = "${pkgs.st}/bin/st";
      };

      lock = mkOption {
        type = types.str;
        default = "${pkgs.slock}/bin/slock";
      };

      run = mkOption {
        type = types.str;
        default = "${pkgs.rofi}/bin/rofi -modi drun -show drun";
      };

      pass = mkOption {
        type = types.str;
        default = "${pkgs.pass}/bin/passmenu";
      };

      editor = mkOption {
        type = types.str;
        default = "${pkgs.emacs}/bin/emacsclient --create-frame";
      };
    };
  };

  config = {
    home.packages = [pkgs.st];
    home.file.".xinitrc".text = ''
        xsetroot -cursor_name left_ptr
        (xrandr --listproviders | grep --quiet NVIDIA-0) && xrandr –setprovideroutputsource modesetting NVIDIA-0
        xrandr --auto
        autocutsel -fork &
        autocutsel -selection PRIMARY -fork &
        eval `dbus-launch --auto-syntax`
        systemctl --user import-environment DISPLAY

        errorlog="$HOME/.xsession-errors"

        ${concatMapStringsSep "\n"
          (svc: "(sleep 3 && systemctl restart ${svc})&")
          config.xsession.autoStartServices}

        if [ -f "~/.Xresources" ]; then
          xrdb merge ~/.Xresources
        fi

        # Start with a clean log file every time
        if ( cp /dev/null "$errorlog" 2> /dev/null ); then
            chmod 600 "$errorlog"
            ${config.xsession.windowManager.command} > "$errorlog" 2>&1
        fi
    '';
    home.file.".xinitrc".executable = true;
  };
}
