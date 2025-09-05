{
  ...
}:

{
  config = {
    nixpkgs.overlays = [
      (self: super: {
        niri-select-window-by-name = super.callPackage ../packages/niri-select-window-by-name { };
        fuzzel = super.fuzzel.overrideAttrs (oldAttrs: {
          version = "117dc1f6d134a7fe5c90de67fb7f695c139f354c";
          src = super.fetchFromGitea {
            domain = "codeberg.org";
            owner = "dnkl";
            repo = "fuzzel";
            rev = "117dc1f6d134a7fe5c90de67fb7f695c139f354c";
            hash = "sha256-QR5YAPgv0GjrNCfzz0xbFNLcoaJExeSQYI+9w1M13u8=";
          };
          buildInputs = (builtins.filter (pkg: pkg.name != "pixman") oldAttrs.buildInputs) ++ [
            self.pixman-046
          ];
          nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ self.pixman-046 ];
        });
        pixman-046 = super.pixman.overrideAttrs (_: rec {
          version = "0.46.4";
          src = super.fetchurl {
            urls = [
              "mirror://xorg/individual/lib/pixman-0.46.4.tar.gz"
              "https://cairographics.org/releases/pixman-0.46.4.tar.gz"
            ];
            hash = "sha256-0JxE68O9W+5wIcefki/o+y+1f3Mg9V6X/5kU0jRqWRw=";
          };
        });
      })
    ];
  };
}
