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
        bambu-studio = prev.callPackage ../packages/bambu-studio/package.nix { };
      })
    ];
  };
}
