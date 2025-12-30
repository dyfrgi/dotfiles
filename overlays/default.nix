{
  ...
}:

{
  config = {
    nixpkgs.overlays = [
      (final: prev: {
        iosvmata = prev.callPackage ../packages/iosvmata.nix { };
        niri-select-window-by-name = prev.callPackage ../packages/niri-select-window-by-name { };
      })
    ];
  };
}
