{ config, lib, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;

  # Set the key GLVidHeapReuseRatio for Niri to reduce how much VRAM it uses.
  # There's some sort of bad buffer handling in the NVidia drivers and this is supposed to help.
  #
  # It's possible that we could use the built-in profile "No VidMem Reuse", but I don't know how
  # the driver parses this stuff.
  environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json" =
    {
      text = builtins.toJSON {
        rules = [
          {
            pattern = {
              feature = "procname";
              matches = "niri";
            };
            profile = "Limit Free Buffer Pool On Wayland Compositors";
          }
        ];
        profiles = [
          {
            name = "Limit Free Buffer Pool On Wayland Compositors";
            settings = [
              {
                key = "GLVidHeapReuseRatio";
                value = 0;
              }
            ];
          }
        ];
      };
    };
}
