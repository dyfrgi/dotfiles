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
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };
    nixGL = {
      url = "github:dyfrgi/nixGL";
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
      overlays.default = (import ./overlays);
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      extraSpecialArgs = { inherit inputs; };
    in
    {
      nixosConfigurations = {
        snail = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            overlays.default
            ./hosts/snail-configuration.nix
            ./hosts/snail-hardware.nix
          ];
        };
        slab = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            overlays.default
            ./hosts/slab-configuration.nix
            ./hosts/slab-hardware.nix
          ];
        };
      };
      homeConfigurations = {
        "mleuchtenburg" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
            username = "mleuchtenburg";
          };
          modules = [
            overlays.default
            ./home.nix
            ./modules-hm/non-nixos.nix
            ./modules-hm/gui.nix
            ./modules-hm/singlestore.nix
          ];
        };
        "msl" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = {
            inherit inputs;
            username = "msl";
          };
          inherit pkgs;
          modules = [
            ./home.nix
            ./modules-hm/gui.nix
          ];
        };
        "msl@splat" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = {
            inherit inputs;
            username = "msl";
          };
          inherit pkgs;
          modules = [
            ./home.nix
          ];
        };
      };
    };
}
