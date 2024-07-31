{
  description = "homelab";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://attic.rzegocki.dev/homelab"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "homelab:kwqUnjVjjHr+9sNlHHOx5KgLUBrwzvG7+ibw2Z/g8uQ="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    arion.url = "github:hercules-ci/arion";
    attic.url = "github:zhaofengli/attic";
    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, arion, attic, comin, home-manager, sops-nix, ... }@inputs:
    {
      nixosConfigurations.router = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit nixpkgs-unstable; };
        modules = [
          ./machines/router

          comin.nixosModules.comin
          sops-nix.nixosModules.sops
        ];
      };
      nixosConfigurations.supervisor = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/supervisor

          arion.nixosModules.arion
          attic.nixosModules.atticd
          comin.nixosModules.comin
          sops-nix.nixosModules.sops
        ];
      };
      nixosConfigurations.piecyk = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./machines/piecyk

          comin.nixosModules.comin
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
        ];
      };

      # homeConfigurations is used by home-manager binary on non-nixos hosts
      # homeConfigurations."ajgon@piecyk" = home-manager.lib.homeManagerConfiguration {
      #   modules = [
      #     ./profiles/personal/core.nix
      #     ./profiles/personal/local.nix
      #     ./profiles/personal/xorg.nix
      #   ];
      # };

      packages = {
        x86_64-linux =
          let
            pkgs = import inputs.nixpkgs {
              system = "x86_64-linux";
            };
          in
          {
            bootstrap = pkgs.writeScriptBin "bootstrap" ''
              ${builtins.readFile ./scripts/bootstrap.sh}
            '';
          };
      };

      apps = {
        x86_64-linux = {
          bootstrap = {
            type = "app";
            program = "${self.packages.x86_64-linux.bootstrap}/bin/bootstrap";
          };
        };
      };
    };
}
