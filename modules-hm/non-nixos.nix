{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  my.wayland.swaylock_path = "/usr/bin/swaylock";
  nixGL.packages = inputs.nixGL.packages;
  home.packages = with pkgs; [ (config.lib.nixGL.wrap niri) ];
  programs.ghostty.package = with pkgs; (config.lib.nixGL.wrap ghostty);
  programs.alacritty.package = with pkgs; (config.lib.nixGL.wrap alacritty);

  home.sessionPath = [ "$HOME/.cargo/bin" ];

  # generate .bashrc with environment variables to pick up e.g. XDG paths for login scripts
  programs.bash.enable = true;
  targets.genericLinux.enable = true;

  # home-manager only sets TERMINFO_DIRS for systemd units, which does not include SSH logins
  home.sessionVariables = {
    TERMINFO_DIRS = "${config.home.homeDirectory}/.nix-profile/share/terminfo";
  };

  home.activation.linkSystemd =
    let
      inherit (lib) hm;
    in
    hm.dag.entryBefore [ "reloadSystemd" ] ''
      mkdir -p $HOME/.local/share/systemd/user/
      find $HOME/.local/share/systemd/user/ \
        -type l \
        -exec bash -c "readlink {} | grep -q $HOME/.nix-profile" \; \
        -delete

      find $HOME/.nix-profile/share/systemd/user \
        -type f -o -type l \
        -exec ln -s {} $HOME/.local/share/systemd/user/ \;
    '';
}
