{ inputs, ... }:
{
  imports = [ inputs.nix-index-database.hmModules.nix-index ];

  config = {
    programs = {
      nix-index-database.comma.enable = true;
    };
  };
}
