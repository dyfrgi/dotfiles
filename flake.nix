{
  description = "Home manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, nix-index-database, ... }@inputs:
  let

      system = "x86_64-linux";
      pkgs = import nixpkgs {inherit system;};
      pkgs-unstable = import nixpkgs-unstable {inherit system;};
      extraSpecialArgs = { inherit pkgs-unstable inputs; };
  in
  {
    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
    homeConfigurations = {
      "mleuchtenburg" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs extraSpecialArgs;
        modules = [
          ./home.nix
          ./modules/gui.nix
        ];
      };
      "msl@snail" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs extraSpecialArgs;
        modules = [
          ./hosts/snail.nix
        ];
      };
      "msl" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs extraSpecialArgs;
        modules = [ 
          ./home.nix
          ./modules/gui.nix
        ];
      };
      "msl@splat" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs extraSpecialArgs;
        modules = [
          ./home.nix
        ];
      };
    };
  };
}
