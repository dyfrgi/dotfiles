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

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    customPaneNavigationAndResize = true; # vi-mode pane navigation hjkl
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    historyLimit = 50000;
    clock24 = true;
  };

  home.packages = with pkgs; [
    acpi
    duckdb
    lftp
    llvmPackages.bintools
    scc
    whois
  ];
}
