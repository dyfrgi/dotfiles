{ inputs, ... }:
{
  imports = [ inputs.nix-index-database.homeModules.nix-index ];

  config = {
    programs = {
      nix-index-database.comma.enable = true;
    };
  };
}
