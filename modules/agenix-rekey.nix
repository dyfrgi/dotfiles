{
  config,
  ...
}:
{
  age.rekey = {
    masterIdentities = [ ../secrets/desktop-age-yubikey.pub ];
    storageMode = "local";
    localStorageDir = ./. + "/../secrets/rekeyed/${config.networking.hostName}";
  };
}
