{pkgs, config, lib, ...}:
{
  xsession.windowManager.awesome = {
    enable = true;
  };

#  services.picom.enable = true;
# Set the picom systemd unit to only start when DISPLAY is set
#  systemd.user.services.picom.Unit.ConditionEnvironment = ["XAUTHORITY"];
}
