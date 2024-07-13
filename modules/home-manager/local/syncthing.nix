{ pkgs, ... }: {
  services.syncthing = {
    enable = true;
  };

  # we need to run syncthing from awesome not via systemd, as the one from nix template, doesn't set QT fonts properly for HIDPI
  home.packages = [
    pkgs.syncthingtray-minimal
  ];
}
