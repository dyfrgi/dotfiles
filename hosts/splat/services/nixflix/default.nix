{
  config,
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = with pkgs; [ recyclarr ];

  # security.acme = {
  #   acceptTerms = true;
  #   defaults.email = "michael+acme@slashhome.org";
  #   defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";
  #   certs."uncri.me" = {
  #     dnsProvider = "porkbun";
  #     environmentFile = config.age.secrets.porkbun_api.path;
  #     group = "nginx";
  #   };
  # };
  #
  # services.nginx.virtualHosts."uncri.me".acmeRoot = null;
  #
  services.nginx.virtualHosts."radarr.uncri.me".locations."/".proxyWebsockets = lib.mkForce true;
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
      # enableACME = true;
      # forceSSL = true;
    };

    # Recyclarr - quality profiles
    recyclarr = {
      enable = true;
      cleanupUnmanagedProfiles = {
        enable = true;
        managedProfiles = [
          "movies"
          "Remux 2160p (Combined)"
          "Remux 2160p (Alternative)"
        ];
      };
      sonarrQuality = "4K";
      config.radarr.radarr = {
        quality_definition = {
          type = "movie";
        };
        quality_profiles = lib.mkForce [
          {
            upgrade = {
              allowed = true;
              until_quality = "Bluray-2160p";
            };
            name = "movies";
            qualities = [
              { name = "Bluray-2160p"; }
              {
                name = "WEB 2160p";
                qualities = [
                  "WEBRip-2160p"
                  "WEBDL-2160p"
                ];
              }
              { name = "Bluray-1080p"; }
              {
                name = "WEB 1080p";
                qualities = [
                  "WEBRip-1080p"
                  "WEBDL-1080p"
                ];
              }
              { name = "HDTV-1080p"; }
              { name = "Bluray-720p"; }
              {
                name = "WEB 720p";
                qualities = [
                  "WEBRip-720p"
                  "WEBDL-720p"
                ];
              }
            ];
          }
          {
            # Remux 2160p (Combined)
            trash_id = "d1d310673359205736b4b84acd5ea8c8";
          }
          {
            # Remux 2160p (Alternative)
            trash_id = "dd3cd75deb9645bae838d1c5da6388d5";
          }
          # { # SQP-1
          #   trash_id = "5128baeb2b081b72126bc8482b2a86a0";
          # }
        ];
      };
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

    # Radarr - Movies
    radarr = {
      enable = true;
      config = {
        apiKey._secret = config.age.secrets.radarr_api_key.path;
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

    # Jellyfin - media server/playback
    jellyfin = {
      enable = true;
      apiKey._secret = config.age.secrets.jellyfin_api_key.path;
      users = {
        smolwaffle = {
          mutable = false;
          password._secret = config.age.secrets.arr_password.path;
          policy.isAdministrator = true;
        };
      };
    };
  };
}
