# Misc commandline utilities I want everywhere
{
  pkgs,
  ...
}:
{
  programs = {
    bat.enable = true;
    eza.enable = true;
    fd.enable = true;
    fzf.enable = true;
    jq.enable = true;
    lazygit.enable = true;
    ripgrep.enable = true;
    yt-dlp.enable = true;
  };
  home.packages = with pkgs; [
    acpi
    lftp
    llvmPackages.bintools
    scc
    whois
  ];
}
