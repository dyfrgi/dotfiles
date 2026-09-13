{
  # Generated
  age.secrets.sonarr_api_key = {
    rekeyFile = ./sonarr_api_key.age;
    generator.script = "base64";
  };
  age.secrets.radarr_api_key = {
    rekeyFile = ./radarr_api_key.age;
    generator.script = "base64";
  };
  age.secrets.prowlarr_api_key = {
    rekeyFile = ./prowlarr_api_key.age;
    generator.script = "base64";
  };
  age.secrets.qbittorrent_password = {
    rekeyFile = ./qbittorrent_password.age;
    generator.script = "alnum";
  };
  age.secrets.sabnzbd_api_key = {
    rekeyFile = ./sabnzbd/api_key.age;
    generator.script = "alnum";
  };
  age.secrets.sabnzbd_nzb_key = {
    rekeyFile = ./sabnzbd/nzb_key.age;
    generator.script = "alnum";
  };

  # Manual
  age.secrets.airvpn_config_splat.rekeyFile = ./airvpn_config_splat.conf.age;
  age.secrets.newshosting_username.rekeyFile = ./newshosting/username.age;
  age.secrets.newshosting_password.rekeyFile = ./newshosting/password.age;
  age.secrets.nzbgeek_apikey.rekeyFile = ./nzbgeek/api_key.age;
  age.secrets.arr_username.rekeyFile = ./arr/username.age;
  age.secrets.arr_password.rekeyFile = ./arr/password.age;
}
