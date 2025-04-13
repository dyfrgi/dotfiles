# Misc commandline utilities I want everywhere
{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    acpi
    bat
    fd # used by telescope-nvim
    fzf
    jq
    lazygit
    llvmPackages.bintools
    ripgrep
    scc
    whois
    yt-dlp
  ];
}
