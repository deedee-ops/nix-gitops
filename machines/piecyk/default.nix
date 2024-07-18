{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./networking.nix

      ../../modules/options.nix

      ../../modules/attic-client.nix
      ../../modules/cache.nix
      ../../modules/locales.nix
      ../../modules/nvidia.nix
      ../../modules/os.nix
      ../../modules/ssh.nix
      ../../modules/sound.nix
      ../../modules/users.nix
      ../../modules/xorg.nix

      ../../modules/home-manager

      ./modules/boot.nix
    ];

  primaryUser = "ajgon";
  currentHostname = config.networking.hostName;
  hmImports = [
    ../../profiles/personal/core.nix
    ../../profiles/personal/local.nix
    ../../profiles/personal/xorg.nix
  ];

  # sops
  sops = {
    defaultSopsFile = ./secrets.sops.yaml;
    age.keyFile = /etc/age/keys.txt;
  };

  # system packages
  environment.systemPackages = with pkgs; [
    git
    home-manager
    vim
  ];

  system.stateVersion = "24.05";
}
