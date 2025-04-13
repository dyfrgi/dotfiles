{
  pkgs,
  ...
}:
(pkgs.writeShellApplication {
  name = "niri-select-window-by-name";
  runtimeInputs = with pkgs; [
    niri
    jq
    fuzzel
  ];
  text = builtins.readFile ./niri-select-window-by-name.sh;
})
