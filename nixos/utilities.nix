{ pkgs, ... }:
{
  config.environment.systemPackages = with pkgs; [
    wget
    net-tools
  ];
}
