{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
  ];

  # generate .bashrc with environment variables to pick up e.g. XDG paths for login scripts
  programs.bash.enable = true;
  targets.genericLinux.enable = true;

  home.packages = [
    pkgs.ghostty.terminfo
  ];

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
