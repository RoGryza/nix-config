{ config, pkgs, lib, ... }:
let
  meta = import /etc/nixos/meta.nix;
in
{
  nixpkgs.config.allowUnfree = true;

  imports = meta.extraImports ++ [./modules/zen-kernel.nix];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = meta.hostname;
  networking.networkmanager.enable = true;

  networking.useDHCP = false;
  networking.interfaces = lib.attrsets.genAttrs meta.networkInterfaces
    (name: { useDHCP = true; });

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.consoleFont = "Lat2-Terminus16";
  i18n.consoleKeyMap = meta.keymap;
  time.timeZone = "America/Sao_Paulo";

  environment.systemPackages = with pkgs; [
    wget vim firefox emacs networkmanager
    xclip autocutsel libnotify slock tmux
    cmake gnumake
    pciutils
    bat fd lsd ripgrep zsh jq yq
    imagemagick p7zip
    # Need to get rid of these
    isync mu
  ];
  environment.pathsToLink = [ "/share/zsh" ];
  security.wrappers.slock.source = "${pkgs.slock.out}/bin/slock";

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  networking.firewall.checkReversePath = false;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.earlyoom = {
    enable = true;
    notificationsCommand = "sudo -u rogryza DISPLAY=:0 notify-send";
  };

  services.xserver.enable = true;
  services.xserver.layout = meta.xkb.layout;
  services.xserver.xkbVariant = meta.xkb.variant;
  services.xserver.xkbOptions = "grp:caps_toggle";

  services.xserver.libinput.enable = true;

  services.xserver.displayManager.startx.enable = true;

  users.mutableUsers = false;
  users.groups.rogryza.gid = 1000;
  users.users.rogryza = {
    uid = 1000;
    isNormalUser = true;
    group = "rogryza";
    hashedPassword = meta.hashedPassword;
    extraGroups = [ "users" "wheel" "networkmanager" "docker" "libvirtd" ];
    shell = pkgs.zsh;
  };

  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;

  system.stateVersion = "20.03";
}
