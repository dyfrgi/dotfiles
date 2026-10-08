{
  pkgs,
  ...
}:
{
  config = {
    programs.nix-ld.enable = true;
    environment.systemPackages = with pkgs; [
      arduino-ide-with-python
      platformio
    ];
  };
}
