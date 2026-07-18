{
  python3,
  lib,
  fetchPypi,
  ...
}:
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "batogram";
  version = "1.8.0";
  pyproject = true;
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "sha256-k2jsojXYH6QXQiWA1rYwcLQxwEyIbJm88OFbKZCsoDw=";
  };

  build-system = with python3.pkgs; [ setuptools ];
  dependencies = with python3.pkgs; [
    # argparse
    dataclasses-json
    hsluv
    numpy
    pillow
    platformdirs
    pyaudio
    scipy
    send2trash
    tkinter
  ];

  pythonRemoveDeps = [
    "argparse"
  ];

  meta = {
    homepage = "https://github.com/jmears63/batogram";
    description = "Application for viewing bat call spectrograms";
    mainProgram = "batogram";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
