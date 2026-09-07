{
  config,
  pkgs,
  lib,
  inputs,
  pkgs-unstable,
  defaultHomeModules,
  ...
}:

let
  zfsRoot =
    let
      devicePath = "/dev/disk/by-id/";
      bootPart = "-part1";
      diskNames = (import ./machine.nix).diskNames;
    in
    {
      disks = lib.lists.imap1 (i: diskName: {
        name = diskName;
        bootDir = "/boot${toString i}";
        bootDev = devicePath + diskName + bootPart;
      }) diskNames;
    };
in
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  age.rekey = {
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMqH61/t2HVr8OnELFdL6pGzmsjlCu3HN6aPidte9VEt";
  };

  imports = [
    # Include the results of the hardware scan.
    ./hardware.nix
    ./virtualization.nix
    # ./services/home-assistant.nix
    ../../modules/packages.nix
    ../../modules/agenix-rekey.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  fileSystems = {
    "/" = {
      device = "rpool/safe/root";
      fsType = "zfs";
    };
    "/home" = {
      device = "rpool/safe/home";
      fsType = "zfs";
    };
    "/var" = {
      device = "rpool/safe/var";
      fsType = "zfs";
    };
    "/var/lib" = {
      device = "rpool/safe/var/lib";
      fsType = "zfs";
    };
    "/var/log" = {
      device = "rpool/safe/var/log";
      fsType = "zfs";
    };
    "/nix" = {
      device = "rpool/local/nix";
      fsType = "zfs";
    };
    "/tmp" = {
      device = "rpool/local/tmp";
      fsType = "zfs";
    };
  }
  // builtins.listToAttrs (
    map (disk: {
      name = disk.bootDir;
      value = {
        device = disk.bootDev;
        fsType = "vfat";
        options = [
          "x-systemd.idle-timeout=1min"
          "x-systemd.automount"
          "noauto"
          "nofail"
        ];
      };
    }) zfsRoot.disks
  );

  services.zfs.autoScrub.enable = true;

  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelPackages = pkgs.linuxPackages_6_12;
  boot.kernelParams = [ "nohibernate" ];
  # Use the GRUB 2 boot loader.
  boot.loader = {
    generationsDir.copyKernels = true;
    efi = {
      canTouchEfiVariables = true;
    };
    grub = {
      enable = true;
      efiSupport = true;
      zfsSupport = true;
      mirroredBoots = (
        map (disk: {
          path = disk.bootDir;
          devices = [ "nodev" ];
        }) zfsRoot.disks
      );
    };
  };

  # systemd.network = {
  #   enable = true;
  #   wait-online.enable = false;
  # };

  networking = {
    useDHCP = false;
    nftables.enable = true;
    firewall.enable = false;
    hostId = "0d6c8487";
    hostName = "splat";
    interfaces.enp39s0.useDHCP = true;
    nat.enable = true;
    nat.internalInterfaces = [ "ve-+" ];
    nat.externalInterface = "enp39s0";
  };

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  programs.zsh.enable = true;
  users.users.msl = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  home-manager = {
    users.msl.imports = defaultHomeModules ++ [
    ];
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs pkgs-unstable;
      username = "msl";
    };
  };

  users.groups.media = {
    members = [
      "msl"
      "jellyfin"
    ];
  };

  users.users.sue = {
    shell = pkgs.zsh;
    isNormalUser = true;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  users.users.sonos = {
    isNormalUser = true;
    hashedPassword = "$6$p5swkn2Umn2bB/Ux$LGvrL5UMVQMLZLxBC9oou6CfQ93KKqNCBs/S3BdL8dS7TYdjVUcFUAAYYFf5UypLAfO6v8aEPPEqvBJedfCfU/"; # luk#Quewec7
  };

  users.users.hpm477 = {
    isNormalUser = true;
  };

  environment.systemPackages = with pkgs; [
    _7zz
    clang
    gnumake
    git
    internetarchive
    jq
    mkvtoolnix-cli
    nftables
    ngrep
    ripgrep
    rtorrent
    silver-searcher
    smartmontools
    stylua
    subtitleedit
    tcpdump
    tmux
    vim
    wireguard-tools
    yt-dlp
  ];

  environment.enableAllTerminfo = true;

  programs.mtr.enable = true;

  # Enable Samba
  services.samba-wsdd.enable = true; # Web Service Device Discovery, needed for some clients
  services.samba = {
    enable = true;
    settings = {
      porn = {
        path = "/data/porn";
        browseable = "no";
        "guest ok" = "no";
        "read only" = "no";
      };
      music = {
        path = "/data/music";
        browseable = "yes";
        "guest ok" = "yes";
        "read only" = "no";
      };
      scans = {
        path = "/data/scans";
        browseable = "yes";
        writeable = "yes";
        "guest ok" = "no";
        "read only" = "no";
      };
      torrents = {
        path = "/data/torrents";
        browseable = "yes";
      };
      sue = {
        path = "/home/sue";
        writeable = "yes";
        "read only" = "no";
      };
      old = {
        path = "/data/old";
        "browseable" = "yes";
      };
      roms = {
        path = "/data/roms";
        "browseable" = "yes";
        "read only" = "no";
        "writeable" = "yes";
      };
    };
  };

  services.syncthing = {
    enable = true;
    user = "msl";
    dataDir = "/home/msl/Sync";
    configDir = "/home/msl/.config/syncthing/";
    guiAddress = "0.0.0.0:8384";
  };

  services.jellyfin = {
    enable = true;
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts."splat" = {
      root = "/var/www";
      locations = {
        "/jellyfin".proxyPass = "http://splat:8096/";
        "/homeassistant".proxyPass = "http://splat:8123";
        "/syncthing".proxyPass = "https://splat:8384";
      };
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  programs.mosh.enable = true;

  system.stateVersion = "22.11";

  hardware.rasdaemon = {
    enable = true;
  };

}
