{
  config,
  ...
}:
{
  imports = [ ../secrets/secrets.nix ];
  age.rekey = {
    masterIdentities = [ ../secrets/desktop-age-yubikey.pub ];
    storageMode = "local";
    localStorageDir = ./. + "/../secrets/rekeyed/${config.networking.hostName}";
  };
}
