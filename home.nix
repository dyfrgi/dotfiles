{pkgs, ...}: {
  home.username = "mleuchtenburg";
  home.homeDirectory = "/home/mleuchtenburg";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
  home.packages = [
    pkgs.neovim
  ];
}
