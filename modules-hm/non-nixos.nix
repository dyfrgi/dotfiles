{ pkgs, ... }:
{
  home.packages = with pkgs; [ niri ];

  # generate .bashrc with environment variables to pick up e.g. XDG paths for login scripts
  programs.bash.enable = true;
  targets.genericLinux.enable = true;
}
