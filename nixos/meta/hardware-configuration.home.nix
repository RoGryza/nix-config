# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  nixpkgs.config.allowUnfree = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices."nixos".device = "/dev/disk/by-uuid/8f24edf3-9d78-4eb5-a844-8fa5fffbc3d0";

  fileSystems."/" =
    { device = "/dev/mapper/nixos";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/F07B-8AF6";
      fsType = "vfat";
    };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  services.xserver.xrandrHeads = [
    {
      output = "eDP-1";
      monitorConfig = ''
      Option "DPMS" "false"
      '';
    }
    {
      output = "HDMI-1";
      monitorConfig = ''
      Option "DPMS" "false"
      '';
    }
  ];

  # services.xserver.videoDrivers = [ "nvidiaLegacy390" ];
  # hardware.bumblebee.enable = true;
  # hardware.bumblebee.driver = "nvidiaLegacy390";

  # environment.etc."X11/xorg.conf.d/10-nvidia-drm-outputclass.conf".text = ''
  # Section "OutputClass"
  #     Identifier "intel"
  #     MatchDriver "i915"
  #     Driver "modesetting"
  # EndSection

  # Section "OutputClass"
  #     Identifier "nvidia"
  #     MatchDriver "nvidia-drm"
  #     Driver "nvidia"
  #     Option "AllowEmptyInitialConfiguration"
  #     Option "PrimaryGPU" "yes"
  # EndSection
  # '';
  # # services.xserver.videoDrivers = [ "intel" "nvidiaLegacy390" ];
  # hardware.opengl.driSupport = true;
  # hardware.opengl.driSupport32Bit = true;
  # hardware.opengl.extraPackages = [
  #   pkgs.libGL_driver
  #   pkgs.linuxPackages.nvidia_x11_legacy390.out
  # ];
  # hardware.nvidia.modesetting.enable = true;
  # hardware.nvidia.optimus_prime.enable = true;
  # hardware.nvidia.optimus_prime.nvidiaBusId = "PCI:8:0:0";
  # hardware.nvidia.optimus_prime.intelBusId = "PCI:0:2:0";
}
