{
  pkgs,
  ...
}:

{
  nixpkgs.overlays = [
    (self: super: {
      niri-select-window-by-name = pkgs.callPackage ../packages/niri-select-window-by-name { };
    })
  ];
}
