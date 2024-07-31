{ inputs, config, lib, ... }:
{
  # Flakes
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    registry = {
      nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
    };
  };

  # save power
  powerManagement.cpuFreqGovernor = "powersave";

  # allow some of the unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.allowUnfree;
}
