# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:

{
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      trusted-users = root msl
    '';
  };

  imports = [
    inputs.nixos-hardware.nixosModules.framework-16-7040-amd
    inputs.home-manager.nixosModules.home-manager
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # turn on debugging for thunderbolt
  boot.kernelParams = [ "thunderbolt.dyndbg=\"module thunderbolt +p\"" ];
  boot.consoleLogLevel = 7;

  # enable boltd and install boltctl
  services.hardware.bolt.enable = true;
  services.fwupd.enable = true;

  boot.initrd.luks.devices."luks-4544ca8f-c06f-4f5a-8725-cfdb9d568749".device =
    "/dev/disk/by-uuid/4544ca8f-c06f-4f5a-8725-cfdb9d568749";
  networking.hostName = "slab";
  networking.networkmanager.enable = true;

  # Work around wpa_supplicant bug spamming CTRL-EVENT-SIGNAL-CHANGE
  systemd.services.wpa_supplicant.serviceConfig = {
    LogLevelMax = "warning";
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  programs.niri.enable = true;
  # Configure swaylock to have access to PAM for unlocking the screen
  security.pam.services.swaylock = { };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.msl = {
    isNormalUser = true;
    description = "Michael Leuchtenburg";
    extraGroups = [
      "root"
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "plugdev"
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

  services.xserver.desktopManager.gnome.enable = true;

  hardware.rtl-sdr.enable = true;
  hardware.enableAllFirmware = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    #    networkmanagerapplet
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

  programs.dconf.enable = true;
  programs.git.enable = true;
  programs.zsh.enable = true;
  programs.nix-index.enable = true;
  programs.command-not-found.enable = false;

  documentation = {
    dev.enable = true;
    nixos.includeAllModules = true;
  };

  services.udev = {
    packages = [ pkgs.via ];
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
}
