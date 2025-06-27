{
  ...
}:

{
  nixpkgs.overlays = [
    (self: super: {
      niri-select-window-by-name = super.callPackage ../packages/niri-select-window-by-name { };
    })
  ];
}
