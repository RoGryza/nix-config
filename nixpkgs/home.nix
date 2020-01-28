{ pkgs, ... }:

let
  meta = import /etc/nixos/meta.nix;
in

{
  home.packages = with pkgs; [
    dropbox
    fasd
    hledger
    mupdf
    pass
    pavucontrol
    pinentry.qt
    rtv
    spotify
    xmobar
  ];

  programs.command-not-found.enable = true;

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    autocd = true;
    shellAliases = {
      e = "emacsclient -nw --alternate-editor=vim";
      ipython = "ipython --no-banner --no-confirm-exit";
      rtv = "rtv --enable-media";
      ls = "lsd";
      tree = "lsd --tree";
      xp = "xclip -selection p";
      xpo = "xclip -selection p -o";
    };
    initExtra = "
    PROMPT=\"%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%} %{$fg_bold[green]%}%~%{$reset_color%}$(git_prompt_info)> \"

    # Don't stop output with ^S
    stty stop undef
    stty start undef
    ";
    profileExtra = "
    export EDITOR='emacsclient --alternate-editor=vim'
    export SUDO_EDITOR=\"$EDITOR\"
    export GIT_EDITOR=\"$EDITOR\"
    export VISUAL=\"$EDITOR\"
    ";
    oh-my-zsh = {
      enable = true;
      plugins = [
        "cargo"
        "colorize"
        "docker"
        "fasd"
        "pass"
        "git"
        "gpg-agent"
        "zsh_reload"
      ];
    };
  };

  programs.gpg = {
    enable = true;
    settings = {
      no-comments = true;
      no-greeting = true;
      armor = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    sshKeys = meta.sshKeyGrips;
    extraConfig = ''
    allow-emacs-pinentry
    allow-loopback-pinentry
    pinentry-program ${pkgs.pinentry.qt}/bin/pinentry
    '';
  };

  systemd.user.services.dropbox = {
    Unit = {
      Description = "Dropbox";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Restart = "on-failure";
      RestartSec = 1;
      ExecStart = "${pkgs.dropbox}/bin/dropbox";
      Environment = "QT_PLUGIN_PATH=/run/current-system/sw/${pkgs.qt5.qtbase.qtPluginPrefix}";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  programs.emacs.enable = true;
  services.emacs.enable = true;

  programs.firefox.enable = true;

  programs.git = {
    enable = true;
    signing.signByDefault = true;
  } // meta.git;

  programs.alacritty = {
    enable = true;
    settings = {
      env = { TERM = "xterm-256color"; };
    };
  };

  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      copycat
      logging
      sessionist
    ];
    extraConfig = builtins.readFile ./lib/tmux.conf;
  };

  programs.rofi.enable = true;

  xsession = {
    enable = true;
    windowManager = {
      xmonad = {
        enable = true;
        extraPackages = hpkgs: with hpkgs; [
          xmonad-contrib
          xmonad-extras
        ];
        enableContribAndExtras = true;
        config = ./lib/xmonad.hs;
      };
    };
  };

  home.file = {
    xinitrc = {
      source = ./lib/xinitrc;
      target = ".xinitrc";
      executable = true;
    };
  };
}
