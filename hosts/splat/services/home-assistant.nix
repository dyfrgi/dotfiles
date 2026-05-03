{pkgs, ...}:
{
  networking.firewall.allowedTCPPorts = [ 8123 ];
  services.home-assistant = {
    enable = true;
    extraComponents = [
      "apple_tv"
      "automation"
      "awair"
      "backup"
      "cast"
      "default_config"
      "dlna_dmr"
      "flux"
      "group"
      "hue"
      "ipp"
      "met"
      "miele"
      "radio_browser"
      "roomba"
      "sonos"
      "spotify"
      "unifi"
      "unifiprotect"
      "webostv"
      "wemo"
      "zha"
    ];
    # package = pkgs.home-assistant.overrideAttrs (previousAttrs: {
    #   # disable flaky test
    #   pytestFlagsArray = previousAttrs.pytestFlagsArray ++ 
    #     [ "--deselect=tests/helpers/test_template.py::test_template_timeout" ];
    #   doInstallCheck = false;
    # });

#   config = {
#     # Includes dependencies for a basic setup
#     # https://www.home-assistant.io/integrations/default_config/
#     default_config = {};
#     "automation ui" = "!include automations.yaml";
#   };
    config = null;
  };

  services.mosquitto = {
    enable = true;
    listeners = [ {
      acl = [ "pattern readwrite #" ];
      omitPasswordAuth = true;
      settings.allow_anonymous = true;
    } ];
  };

  services.zigbee2mqtt = {
    enable = true;
    settings = {
      serial = {
          port = "/dev/serial/by-id/usb-ITead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_b8f9cde6d99ded118b99d7a5a7669f5d-if00-port0";
          adapter = "zstack";
      };
      homeassistant.enabled = true;
      frontend = true;
      permit_join = false;
    };
  };

  environment.systemPackages =with pkgs; [
    home-assistant-cli
  ];
}
