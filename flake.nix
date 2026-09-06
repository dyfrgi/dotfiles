{
  description = "Home manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      agenix,
      agenix-rekey,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      overlays.default = (import ./overlays);
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      extraSpecialArgs = { inherit inputs pkgs-unstable; };
      defaultHomeModules = [ ./home ];

      nixosArgs = name: {
        specialArgs = { inherit inputs pkgs-unstable defaultHomeModules; };
        modules = [
          ./hosts/${name}/configuration.nix
          ./nixos
          overlays.default
        ];
      };

      # maybe add primamryUser to mjNixos?
      mkNixos =
        name: prev:
        nixpkgs.lib.nixosSystem (
          (nixosArgs name)
          // {
            inherit pkgs;
          }
          // prev
        );
    in
    {
      nixosConfigurations = {
        snail = mkNixos "snail" {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.default
            agenix-rekey.nixosModules.default
          ];
        };
        slab = mkNixos "slab" {
          system = "x86_64-linux";
        };
        splat = mkNixos {
          system = "x86_64-linux";
        };
      };
      homeConfigurations = {
        "mleuchtenburg" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = extraSpecialArgs // {
            username = "mleuchtenburg";
          };
          modules = defaultHomeModules ++ [
            overlays.default
            ./modules-hm/non-nixos.nix
            ./modules-hm/non-nixos-gui.nix
            ./modules-hm/gui.nix
            ./modules-hm/singlestore.nix
          ];
        };
        "mleuchtenburg@msl" = home-manager.lib.homeManagerConfiguration {
          # work coder instance
          inherit pkgs;
          extraSpecialArgs = extraSpecialArgs // {
            username = "mleuchtenburg";
          };
          modules = defaultHomeModules ++ [
            overlays.default
            ./modules-hm/non-nixos.nix
            ./modules-hm/singlestore.nix
          ];
        };
        "msl" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = extraSpecialArgs // {
            username = "msl";
          };
          inherit pkgs;
          modules = defaultHomeModules ++ [
            ./modules-hm/gui.nix
          ];
        };
        "msl@splat" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = extraSpecialArgs // {
            username = "msl";
          };
          inherit pkgs;
          modules = defaultHomeModules ++ [
          ];
        };
      };
      agenix-rekey = agenix-rekey.configure {
        userFlake = self;
        nixosConfigurations = self.nixosConfigurations;
      };
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          agenix-rekey.packages.${system}.default
          pkgs.age-plugin-yubikey
          pkgs.rage
          pkgs.age
        ];
        env.AGENIX_REKEY_ADD_TO_GIT = "true";
      };
    };
}
