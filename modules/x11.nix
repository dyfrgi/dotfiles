{pkgs, config, lib, ...}:
{
  xsession.windowManager.awesome = {
    enable = true;
  };

  services.picom.enable = true;
}
