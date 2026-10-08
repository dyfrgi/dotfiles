{
  lib,
  symlinkJoin,
  python3,
  arduino-ide,
  makeWrapper,
}:
let
  arduino-python = python3.withPackages (ps: with ps; [ pyserial ]);
in
symlinkJoin {
  name = "arduino-ide-wrapped-${arduino-ide.version}";
  paths = [ arduino-ide ];
  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/arduino-ide \
      --prefix PATH : ${lib.makeBinPath [ arduino-python ]}
  '';

  # Preserve the original metadata
  meta = arduino-ide.meta // {
    description = "Arduino IDE wrapped with Python and pyserial for ESP32 toolchain support";
    mainProgram = "arduino-ide";
  };
}
