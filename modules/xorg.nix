{ pkgs, ... }:
{
  services = {
    displayManager.sddm = {
      enable = true;
      theme = "catppuccin-sddm-corners";
    };

    xserver = {
      enable = true;
      windowManager.awesome.enable = true;
    };
  };

  environment.systemPackages = [
    pkgs.catppuccin-sddm-corners
  ];
}
