{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-16-7040-amd
    inputs.home-manager.nixosModules.home-manager
  ];

  config = {
    hardware = {
      rtl-sdr.enable = true;
      enableAllFirmware = true;
      bluetooth.enable = true;
    };

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

    boot = {
      # 6.12 is the most recent LTS kernel
      kernelPackages = pkgs.linuxKernel.packages.linux_6_12;
      # turn on debugging for thunderbolt
      kernelParams = [ "thunderbolt.dyndbg=\"module thunderbolt +p\"" ];
      consoleLogLevel = 7;
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      initrd.luks.devices."luks-4544ca8f-c06f-4f5a-8725-cfdb9d568749".device =
        "/dev/disk/by-uuid/4544ca8f-c06f-4f5a-8725-cfdb9d568749";
    };

    networking = {
      hostName = "slab";
      networkmanager.enable = true;
    };

    services.tailscale.enable = true;

    # Work around wpa_supplicant bug spamming CTRL-EVENT-SIGNAL-CHANGE
    systemd.services.wpa_supplicant.serviceConfig = {
      LogLevelMax = "warning";
    };

    # Set your time zone.
    time.timeZone = "America/New_York";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    services = {
      displayManager.sddm.enable = true;
      fwupd.enable = true;
      # enable boltd and install boltctl
      hardware.bolt.enable = true;
      xserver.enable = true;

      # needed udev rules for via, which configures the Framework 16 keyboard
      udev = {
        packages = [ pkgs.via ];
      };
    };

    environment.enableDebugInfo = true;

    programs.niri.enable = true;
    # Configure swaylock to have access to PAM for unlocking the screen
    security.pam.services.swaylock = { };

    users.users.msl = {
      isNormalUser = true;
      description = "Michael Leuchtenburg";
      extraGroups = [
        "audio"
        "dialout" # ttyUSB
        "networkmanager"
        "plugdev"
        "root"
        "video"
        "wheel"
      ];
      shell = pkgs.zsh;
    };

    users.users.maria = {
      isNormalUser = true;
      description = "Maria Mrowicki";
      extraGroups = [
        "networkmanager"
        "audio"
        "video"
      ];
      packages = with pkgs; [
        google-chrome
        firefox
      ];
    };

    users.users.guest = {
      isNormalUser = true;
      description = "Guest";
      extraGroups = [
        "networkmanager"
        "audio"
        "video"
      ];
      packages = with pkgs; [
        google-chrome
        firefox
      ];
    };

    # Install Gnome for Maria
    services.xserver.desktopManager.gnome.enable = true;

    programs.dconf.enable = true;
    programs.git.enable = true;
    programs.zsh.enable = true;
    programs.nix-index.enable = true;
    programs.command-not-found.enable = false;

    environment.systemPackages = with pkgs; [
      amd-debug-tools
      pamixer
      pciutils
      pstree
      (callPackage ../packages/rtlamr.nix { })
      rtl-sdr
      swaylock
      usbutils

      # documentation
      man-pages
      man-pages-posix
      linux-manual
    ];

    documentation = {
      dev.enable = true;
      nixos.includeAllModules = true;
    };

    system.stateVersion = "23.11";

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
