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
    };
  };
}
