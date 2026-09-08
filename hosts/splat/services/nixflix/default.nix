{ config, ... }:
{
  nixflix = {
    enable = true;
    mediaDir = "/data/media";
    downloadsDir = "/data/media/downloads";
    sonarr = {
      enable = true;
      config = {
        apiKey._secret = config.age.secrets.sonarr_api_key.path;
        hostConfig = {
          username = "msl";
          password = "whatever";
        };
      };
    };
  };
}
