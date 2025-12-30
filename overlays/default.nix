{
  ...
}:

{
  config = {
    nixpkgs.overlays = [
      (final: prev: {
        iosvmata = prev.callPackage ../packages/iosvmata.nix { };
        niri-select-window-by-name = prev.callPackage ../packages/niri-select-window-by-name { };

        # bambu-studio when using the nixpkgs version has two bugs:
        # 1. It crashes on exit with a bad free in std::locale
        # 2. It does not display previews on at least NVidia
        #
        # The second one can be worked around by setting some environment variables to use
        # the zink renderer from Mesa and Gallium, but the first one has no known workaround.
        # Thus, we will wrap the appimage instead.
        bambu-studio = prev.appimageTools.wrapType2 rec {
          name = "BambuStudio";
          pname = "bambu-studio";
          version = "02.04.00.70";
          ubuntu_version = "24.04_PR-8834";

          src = prev.fetchurl {
            url = "https://github.com/bambulab/BambuStudio/releases/download/v${version}/Bambu_Studio_ubuntu-${ubuntu_version}.AppImage";
            sha256 = "sha256:26bc07dccb04df2e462b1e03a3766509201c46e27312a15844f6f5d7fdf1debd";
          };

          profile = ''
            export SSL_CERT_FILE="${prev.cacert}/etc/ssl/certs/ca-bundle.crt"
            export GIO_MODULE_DIR="${prev.glib-networking}/lib/gio/modules/"
          '';

          extraPkgs =
            pkgs: with pkgs; [
              cacert
              glib
              glib-networking
              gst_all_1.gst-plugins-bad
              gst_all_1.gst-plugins-base
              gst_all_1.gst-plugins-good
              webkitgtk_4_1
            ];
        };
      })
    ];
  };
}
