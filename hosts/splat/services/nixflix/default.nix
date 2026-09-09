{ config, ... }:
{
  nixflix = {
    enable = true;
    mediaDir = "/data/media";
    downloadsDir = "/data/media/downloads";
    vpn = {
      enable = true;
      accessibleFrom = [ "192.168.1.0/24" ];
      openVPNPorts = [
        {
          port = 63633;
          protocol = "both";
        }
      ];
      wgConfFile = config.age.secrets.airvpn_config_splat.path;
    };
    nginx = {
      enable = true;
      domain = "uncri.me";
    };

    # Recyclarr - quality profiles
    recyclarr = {
      enable = true;
      cleanupUnmanagedProfiles.enable = true;
      sonarrQuality = "4K";
    };

    # Sonarr - TV
    sonarr = {
      enable = true;
      config = {
        apiKey._secret = config.age.secrets.sonarr_api_key.path;
        hostConfig = {
          username._secret = config.age.secrets.arr_username.path;
          password._secret = config.age.secrets.arr_password.path;
        };
        delayProfiles = [
          {
            enableUsenet = true;
            enableTorrent = true;
            preferredProtocol = "usenet";
            usenetDelay = 0;
            torrentDelay = 0;
            bypassIfHighestQuality = true;
            id = 1;
          }
        ];
      };
    };

    # Prowlarr - Indexers
    prowlarr = {
      enable = true;
      config = {
        apiKey._secret = config.age.secrets.prowlarr_api_key.path;
        hostConfig.username._secret = config.age.secrets.arr_username.path;
        hostConfig.password._secret = config.age.secrets.arr_password.path;
        indexers = [
          # NZB indexers
          {
            enable = true;
            name = "NZBgeek";
            apiKey._secret = config.age.secrets.nzbgeek_apikey.path;
          }

          # Torrent indexers
          {
            enable = true;
            name = "Nyaa.si";
            baseUrl = "https://nyaa.si/";
            radarr_compatibility = true;
            sonarr_compatibility = true;
          }
          {
            enable = true;
            name = "YTS";
            baseUrl = "https://yts.bz/";
          }
        ];
      };
    };

    # Download clients
    torrentClients.qbittorrent = {
      enable = true;
      password._secret = config.age.secrets.arr_password.path;
      serverConfig = {
        LegalNotice.Accepted = true;
        BitTorrent = {
          Session = {
            Port = 63633;
            ReannounceWhenAddressChanged = true;
          };
        };
        Preferences = {
          WebUI = {
            Username = "smolwaffle";
            Password_PBKDF2 = "@ByteArray(iUsNr64A3Eh84pfOEUXr9Q==:5d6csNBNtKCnx7C3cDn45WslQVnQzrjOnGJZgd8tByGV8OeZ710i9Vd4WADxCtYudHXkj4ZCJY3rvTFUNnbXqw==)";
          };
        };
      };
    };
    usenetClients.sabnzbd = {
      enable = true;
      vpn.enable = false;
      settings = {
        misc = {
          username._secret = config.age.secrets.arr_username.path;
          password._secret = config.age.secrets.arr_password.path;
          api_key._secret = config.age.secrets.sabnzbd_api_key.path;
          nzb_key._secret = config.age.secrets.sabnzbd_nzb_key.path;
        };
        servers = [
          {
            name = "Newshosting";
            host = "news.newshosting.com";
            port = 563;
            username._secret = config.age.secrets.newshosting_username.path;
            password._secret = config.age.secrets.newshosting_password.path;
            connections = 20;
            ssl = true;
            priority = 0;
          }
        ];
      };
    };
  };
}
