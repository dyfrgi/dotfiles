{ pkgs, ... }:
{
  virtualisation = {
    incus = {
      enable = true;
      ui.enable = true;
      preseed = {
        storage_pools = [
          {
            name = "zfs-incus";
            driver = "zfs";
            config = {
              source = "rpool/safe/incus";
            };
          }
        ];
        profiles = [
          {
            name = "default";
            devices = {
              eth0 = {
                name = "eth0";
                network = "incusbr0";
                type = "nic";
              };
              root = {
                path = "/";
                pool = "zfs-incus";
                type = "disk";
              };
            };
          }
          {
            name = "bridged";
            devices = {
              eth0 = {
                name = "eth0";
                type = "nic";
                network = "incusbr1";
              };
            };
          }
        ];
        networks = [
          {
            name = "incusbr0";
            type = "bridge";
            config = {
              "ipv4.address" = "10.0.100.1/24";
              "ipv4.nat" = "true";
            };
          }
          {
            name = "incusbr1";
            type = "macvlan";
            config = {
              parent = "enp39s0";
            };
          }
        ];
      };
    };
    libvirtd.enable = true;
  };
}
