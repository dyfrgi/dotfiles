{
  appimageTools,
  fetchurl,
  pkgs,
}:
let
  name = "BambuStudio";
  pname = "bambu-studio";
  version = "02.08.02.61";
  ubuntu_version = "24.04";
  build_timestamp = "20260820225108";
  src = fetchurl {
    url = "https://github.com/bambulab/BambuStudio/releases/download/v${version}/BambuStudio_ubuntu${ubuntu_version}-v${version}-${build_timestamp}.AppImage";
    sha256 = "sha256-1QGxA/rFQkUT7A6Na8FF+zBxneLH2U1zINcjdAyBp/0=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit
    name
    pname
    version
    src
    ;

  profile = ''
    export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
    export GIO_MODULE_DIR="${pkgs.glib-networking}/lib/gio/modules/"
    export __GLX_VENDOR_LIBRARY_NAME="mesa"
    export __EGL_VENDOR_LIBRARY_FILENAMES="${pkgs.mesa.drivers}/share/glvnd/egl_vendor.d/50_mesa.json"
    export MESA_LOADER_DRIVER_OVERRIDE="zink"
    export GALLIUM_DRIVER="zink"
    export WEBKIT_DISABLE_COMPOSITING_MODE=1
    export WEBKIT_DISABLE_DMABUF_RENDERER=1
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

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/BambuStudio.desktop $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/128x128/apps/BambuStudio.png \
                      $out/share/icons/hicolor/128x128/apps/BambuStudio.png
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
  '';
}
