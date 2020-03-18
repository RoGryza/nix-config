{ config, lib, pkgs, ... }:
with lib;
{
  imports = [
    ./dwm
  ];

  options.xsession = {
    autoStartServices = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };

  config = {
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
          (svc: "(sleep 3 && systemctl --user restart ${svc})&")
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
