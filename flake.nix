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
    nixflix = {
      url = "github:kiriwalawren/nixflix";
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
        inherit pkgs;
        specialArgs = { inherit inputs pkgs-unstable defaultHomeModules; };
        modules = [
          ./hosts/${name}/configuration.nix
          ./nixos
          overlays.default
        ];
      };

      # maybe add primaryUser to mkNixos?
      mkNixos = host: cfg: nixpkgs.lib.nixosSystem ((nixosArgs host) // cfg);

      homeArgs = username: hostname: {
        inherit pkgs;
        extraSpecialArgs = extraSpecialArgs // {
          inherit username hostname;
        };
        modules = defaultHomeModules ++ [
          overlays.default
          ./hosts/${hostname}/home.nix
        ];
      };

      # Profile names are "<username>@<host>": the host picks hosts/<host>/home.nix,
      # and both halves are threaded through extraSpecialArgs as username/hostname.
      mkHome =
        name:
        let
          parts = nixpkgs.lib.splitString "@" name;
        in
        home-manager.lib.homeManagerConfiguration (
          homeArgs (builtins.elemAt parts 0) (builtins.elemAt parts 1)
        );
    in
    {
      nixosConfigurations = {
        snail = mkNixos "snail" {
          system = "x86_64-linux";
        };
        slab = mkNixos "slab" {
          system = "x86_64-linux";
        };
        splat = mkNixos "splat" {
          system = "x86_64-linux";
        };
      };
      homeConfigurations = nixpkgs.lib.genAttrs [
        "mleuchtenburg@mleuchtenburg"
        "mleuchtenburg@msl"
      ] mkHome;
      agenix-rekey = agenix-rekey.configure {
        userFlake = self;
        nixosConfigurations = (nixpkgs.lib.filterAttrs (name: _: name != "slab") self.nixosConfigurations);
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
