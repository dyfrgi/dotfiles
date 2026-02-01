{
  pkgs,
  ...
}:
{
  config = {
    programs.nix-ld.enable = true;
    environment.systemPackages = with pkgs; [
      platformio
    ];
  };
}
