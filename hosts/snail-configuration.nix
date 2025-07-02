{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ../modules/nvidia.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  config = {
    hardware = {
      enableAllFirmware = true;
      bluetooth.enable = true;
    };
    services.blueman.enable = true;

    nix.settings = {
      experimental-features = [
        "flakes"
        "nix-command"
      ];
      trusted-users = [
        "root"
        "msl"
      ];
    };

    # Use the systemd-boot EFI boot loader.
    boot = {
      kernelPackages = pkgs.linuxKernel.packages.linux_6_13;
      kernelParams = [ "split_lock_detect=off" ];
      zfs.package = pkgs.zfs_2_3;
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      kernelModules = [ "nct6687" ];
      extraModulePackages = with config.boot.kernelPackages; [ nct6687d ];
      kernel.sysctl = {
        "kernel.split_lock_mitigate" = 0;
      };

      initrd.luks.devices = {
        "luks-rpool-nvme-Samsung_SSD_990_PRO_4TB_S7KGNU0XB18547R-part2".device =
          "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_4TB_S7KGNU0XB18547R-part2";
        "luks-rpool-2db8467e-0da0-4dce-ba3d-cf04c2ab68c4".device =
          "/dev/disk/by-uuid/2db8467e-0da0-4dce-ba3d-cf04c2ab68c4";
      };
    };

    networking = {
      hostName = "snail"; # Define your hostname.
      networkmanager.enable = true; # Easiest to use and most distros use this by default.
    };

    # Set your time zone.
    time.timeZone = "America/New_York";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    services = {
      displayManager.sddm.enable = true;
      flatpak.enable = true;
      fwupd.enable = true;
      nixseparatedebuginfod.enable = true;
      pipewire = {
        enable = true;
        pulse.enable = true;
      };
      udisks2.enable = true;
      xserver.enable = true;
    };

    environment.enableDebugInfo = true;

    programs.niri.enable = true;
    security.pam.services.swaylock = { };

    # Enable sound.
    security.rtkit.enable = true;
    users.users.msl = {
      isNormalUser = true;
      description = "Michael Leuchtenburg";
      extraGroups = [
        "audio"
        "dialout" # ttyUSB
        "networkmanager"
        "plugdev"
        "video"
        "wheel"
      ];
      shell = pkgs.zsh;
    };

    programs.firefox.enable = true;
    programs.zsh.enable = true;

    programs.git.enable = true;
    programs.steam.enable = true;
    programs.steam.gamescopeSession.enable = true;
    programs.gamemode.enable = true;
    programs.gamescope = {
      enable = true;
      package = with pkgs; enableDebugging gamescope;
    };

    environment.systemPackages = with pkgs; [
      cifs-utils
      gdb
      nvd
      pciutils
      usbutils
      xwayland-run
      xwayland-satellite

      man-pages
      man-pages-posix
      linux-manual
    ];

    documentation = {
      dev.enable = true;
      nixos.includeAllModules = true;
    };

    system.stateVersion = "25.05";

    # Required for XDG portal definitions from home-manager
    environment.pathsToLink = [
      "/share/xdg-desktop-portal"
      "/share/applications"
    ];

    home-manager = {
      users.msl.imports = [
        ../home.nix
        ../modules-hm/gui.nix
        ../modules-hm/gaming.nix
        ../modules-hm/3dprinting.nix
        ../modules-hm/personal.nix
        ../modules-hm/vm.nix
      ];
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs;
        username = "msl";
      };
    };
  };
}
