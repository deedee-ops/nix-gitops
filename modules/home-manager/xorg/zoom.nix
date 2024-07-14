{ pkgs, config, ... }: let
    zoomwrapper = pkgs.writeShellScriptBin "zoom-wrapper" ''
      #!${pkgs.coreutils-full}/bin/env ${pkgs.bash}/bin/bash

      TARGET="https://app.zoom.us/wc/$(echo "$@" | awk -F/ '{ print $NF }' | grep -Eo '(^|=)[0-9]{10,}' | tr -d '=')/join"
      ZOOM_PASSWORD="$(echo "$@" | grep -Eo '[?&]pwd=[^&]+' | tr '&' '?')"

      ${pkgs.ungoogled-chromium}/bin/chromium --app="$TARGET$ZOOM_PASSWORD" --class="Zoom" --user-data-dir="${config.xdg.stateHome}/zoom"
    '';
  in {
  # fake implementation via chromium browser - a.k.a. poor man's sandboxing
  home = {
    packages = [
      zoomwrapper

      pkgs.ungoogled-chromium
    ];
  };

  xdg.dataFile = {
    "applications/Zoom.desktop".text = ''
      [Desktop Entry]
      Name=Zoom
      Comment=Zoom Video Conference
      Exec=${zoomwrapper}/bin/zoom-wrapper %U
      Icon=Zoom
      Terminal=false
      Type=Application
      Encoding=UTF-8
      Categories=Network;Application;
      StartupWMClass=zoom
      MimeType=x-scheme-handler/zoommtg;x-scheme-handler/zoomus;x-scheme-handler/tel;x-scheme-handler/callto;x-scheme-handler/zoomphonecall;application/x-zoom
      X-KDE-Protocols=zoommtg;zoomus;tel;callto;zoomphonecall;
      Name[en_US]=Zoom
    '';
  };

  xdg.mimeApps = {
    defaultApplications = {
      "x-scheme-handler/zoommtg" = "Zoom.desktop";
      "x-scheme-handler/zoomus" = "Zoom.desktop";
      "x-scheme-handler/tel" = "Zoom.desktop";
      "x-scheme-handler/callto" = "Zoom.desktop";
      "x-scheme-handler/zoomphonecall" = "Zoom.desktop";
      "application/x-zoom" = "Zoom.desktop";
    };
  };
}

