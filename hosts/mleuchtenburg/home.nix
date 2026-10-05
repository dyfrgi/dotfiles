# work laptop
{ ... }:
{
  imports = [
    ../../modules-hm/non-nixos.nix
    ../../modules-hm/non-nixos-gui.nix
    ../../modules-hm/gui.nix
    ../../modules-hm/singlestore.nix
  ];
}
