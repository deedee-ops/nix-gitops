{ pkgs, ... }:
let
  grubTheme = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "grub";
    rev = "v1.0.0";
    sha256 = "sha256-/bSolCta8GCZ4lP0u5NVqYQ9Y3ZooYCNdTwORNvR7M0=";
  };
in {
  boot = {
    loader = {
      # systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
        theme = "${grubTheme}/src/catppuccin-mocha-grub-theme";
      };
    };
    plymouth = {
      enable = true;
      themePackages = [ (pkgs.catppuccin-plymouth.override { variant = "mocha"; }) ];
      theme = "catppuccin-mocha";
    };
  };
}
