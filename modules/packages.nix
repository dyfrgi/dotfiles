{
  config,
  pkgs,
  ...
}:
{
  config.environment.systemPackages = with pkgs; [
    config.boot.kernelPackages.perf
    lsof
    nvd
    pciutils
    usbutils
  ];
}
