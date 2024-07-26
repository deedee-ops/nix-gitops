{ inputs, pkgs, lib, ... }:
let
  nixGL = import ./nixgl.nix { inherit inputs; };
in
{
  imports = [
    ./awesome.nix
    ./betterlockscreen.nix
    ./dunst.nix
    ./firefox.nix
    ./fonts.nix
    ./gtk.nix
    ./picom.nix
    ./qt.nix
    ./redshift.nix
    ./rofi.nix
    ./zathura.nix
    ./zoom.nix
  ];

  home = {
    pointerCursor = {
      name = "catppuccin-mocha-dark-cursors";
      size = 48;
      package = pkgs.catppuccin-cursors.mochaDark;
      x11.enable = true;
      gtk.enable = true;
    };

    packages = [
      (nixGL pkgs.alacritty)
      (nixGL pkgs.mpv)

      pkgs.discord
      pkgs.obsidian
      pkgs.slack
      pkgs.telegram-desktop
      pkgs.whatsapp-for-linux
      pkgs.ungoogled-chromium # for webapps
    ];
  };

  services.gpg-agent.pinentryPackage = lib.mkForce pkgs.pinentry-gtk2;

  xdg.configFile."whatsapp-for-linux/settings.conf".text = ''
    [general]
    notification-sounds=true
    close-to-tray=true
    start-in-tray=false
    zoom-level=1.00

    [web]
    hw-accel=2
    allow-permissions=true
    min-font-size=0

    [appearance]
    prefer-dark-theme=true
  '';
}
