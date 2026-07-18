{
  pkgs,
  ...
}:
let
  batogram = pkgs.callPackage ../packages/batogram { };
in
{
  home.packages = with pkgs; [
    audacity
    batogram
  ];
}
