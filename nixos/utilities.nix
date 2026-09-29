{ pkgs, ... }:
{
  config.environment.systemPackages = with pkgs; [
    iperf3
    wget
    net-tools
  ];
}
