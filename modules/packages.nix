{
  pkgs,
  ...
}:
{
  config.environment.systemPackages = with pkgs; [
    perf
    lsof
    nvd
    pciutils
    usbutils
  ];
}
