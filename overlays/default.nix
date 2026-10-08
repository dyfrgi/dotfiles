{
  ...
}:

{
  config = {
    nixpkgs.overlays = [
      (final: prev: {
        iosvmata = prev.callPackage ../packages/iosvmata.nix { };
        niri-select-window-by-name = prev.callPackage ../packages/niri-select-window-by-name { };
        arduino-ide-with-python = prev.callPackage ../packages/arduino-with-python.nix { };

        # bambu-studio when using the nixpkgs version has two bugs:
        # 1. It crashes on exit with a bad free in std::locale
        # 2. It does not display previews on at least NVidia
        #
        # The second one can be worked around by setting some environment variables to use
        # the zink renderer from Mesa and Gallium, but the first one has no known workaround.
        # Thus, we will wrap the appimage instead.
        bambu-studio = prev.callPackage ../packages/bambu-studio/package.nix { };

        # disable openldap tests for i686 build used by bottles, etc
        # TODO: re-enable this after the build is fixed in nixpkgs, probably with the release of 26.05
        openldap =
          if prev.stdenv.hostPlatform.system == "i686-linux" then
            prev.openldap.overrideAttrs (_: {
              doCheck = false;
            })
          else
            prev.openldap;
        gamescope = prev.gamescope.overrideAttrs (oldAttrs: {
          NIX_CFLAGS_COMPILE = (oldAttrs.NIX_CFLAGS_COMPILE or [ ]) ++ [ "-fno-fast-math" ];
        });
        coder = prev.coder.overrideAttrs (
          newAttrs: oldAttrs: {
            version = "2.34.5";
            src = prev.fetchurl {
              hash = "sha256-B0roCJqTu6o89nHbVA3b9eHKj/VmJ9i1j4blF1I76yU=";
              url = builtins.replaceStrings [ oldAttrs.version ] [ newAttrs.version ] oldAttrs.src.url;
            };
          }
        );
      })
    ];
  };
}
