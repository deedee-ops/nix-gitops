{ pkgs, inputs, ... }:
let
  nixGL = import ./nixgl.nix { inherit inputs; };
in {
  home = {
    packages = [
      (nixGL pkgs.firefox)
      pkgs.ffmpeg-full
      pkgs.libva-utils
      pkgs.libva
      pkgs.nvidia-vaapi-driver
    ];
    sessionVariables = {
      MOZ_DISABLE_RDD_SANDBOX = "1";
      LIBVA_DRIVER_NAME = "nvidia";
      LIBVA_DRIVERS_PATH = "${pkgs.nvidia-vaapi-driver}/lib/dri/";
      NVD_BACKEND = "direct";
      DEFAULT_BROWSER = "${(nixGL pkgs.firefox)}/bin/firefox";
    };
  };

  xdg.mimeApps = {
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };
}
