{
  description = "Home manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let

      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      extraSpecialArgs = { inherit inputs; };
    in
    {
      nixosConfigurations = {
        snail = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (import ./overlays)
            ./configuration.nix
            ./hardware-configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.msl = import ./hosts/snail.nix;
                inherit extraSpecialArgs;
              };
            }
          ];
        };
      };
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
