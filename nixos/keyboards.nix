{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.my.keyboards;
in
{
  options = {
    my.keyboards.enable = lib.options.mkEnableOption "enable keyboard configuration packages and udev rules";
  };
  config = lib.mkIf cfg.enable {
    hardware.keyboard.qmk = {
      enable = true;
      keychronSupport = true;
    };
  };
}
