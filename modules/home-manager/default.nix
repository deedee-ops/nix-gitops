{ config, inputs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };

    users."${config.primaryUser}" = {
      imports = [
        inputs.sops-nix.homeManagerModules.sops
      ] ++ config.hmImports;
    };
  };

  allowUnfree = [
    # fonts
    "corefonts"
    "helvetica-neue-lt-std"

    # apps
    "discord"
    "obsidian"
    "slack"
  ];
}
