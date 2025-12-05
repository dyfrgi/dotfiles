{
  stdenv,
  fetchzip,
  zstd,
}:
let
  pname = "iosvmata";
  version = "1.2.0";
  src = fetchzip {
    nativeBuildInputs = [ zstd ];
    url = "https://github.com/N-R-K/Iosvmata/releases/download/v${version}/Iosvmata-v${version}.tar.zst";
    hash = "sha256-CvIXUbnxqVPV6rf0vr2rMQojvgMyqPPQIO7Cr8ItTgg=";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    install --mode=644 $src/Nerd/*.ttf $out/share/fonts/truetype
  '';

  meta = {
    description = "Custom Iosevka build somewhat mimicking PragmataPro";
    homepage = "https://github.com/N-R-K/Iosvmata";
  };
}
