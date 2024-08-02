{ pkgs, inputs, config, osConfig, ... }:
let
  nixGL = import ./nixgl.nix { inherit inputs; };
in
{
  programs.autorandr = {
    enable = true;

    profiles = {
      "${osConfig.currentHostname}" = {
        fingerprint = {
          "DP-2" = "00ffffffffffff000472b1061c118194301d0104b53c22783b2711ac5135b5260e50542348008140818081c081009500b300d1c001014dd000a0f0703e803020350055502100001ab46600a0f0701f800820180455502100001a000000fd0c3090ffff6b010a202020202020000000fc0058563237334b0a2020202020200247020343f151010304121305141f9007025d5e5f60613f2309070783010000e200c06d030c0010003878200060010203681a00000101309000e305e301e606070161561c0782805470384d400820f80c56502100001a40e7006aa0a06a500820980455502100001a6fc200a0a0a055503020350055502100001e0000000000007870127900000301289aa00184ff0ea0002f8021006f083e0003000500e0f600047f0759002f801f006f081900010003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003590";
          "DP-0" = "00ffffffffffff000472830b000000000c210104b53c21783b1f51ae4e33a422125054bfef80714f8140818081c09500b300d1c0d1fc4dd000a0f0703e803020350055502100001a000000ff0039333132303239413032583030000000fd0030a0ffff82010a202020202020000000fc0058563237354b20560a2020202002a8020345f2555d5e5f6061014003111213040e0f1d1e1f903f75762309070783010000e305c301e20f18e30e7576e200d5e60605016969006d1a0000020130a00000695500006a5e00a0a0a029503020350055502100001e000000000000000000000000000000000000000000000000000000000000000000000000000000007970126700000300648cee0104ff0e9f002f001f006f082500020004001f9c0104ff0e9f002f001f006f08250002000400e51e0204ff0e81002f001f006f081b0002000400d3bc0004ff099f002f001f009f05280002000400378b00047f07170157002b0037042c00030004007e00000000000000000000000000000000000090";
        };
        config = {
          "DP-2" = {
            crtc = 0;
            dpi = 192;
            enable = true;
            gamma = "1.099:1.0:0.909";
            mode = "3840x2160";
            position = "0x0";
            primary = true;
            rate = "119.91";
          };
          "DP-0" = {
            crtc = 1;
            dpi = 192;
            enable = true;
            gamma = "1.099:1.0:0.909";
            mode = "3840x2160";
            position = "3840x0";
            rate = "120.00";
          };
        };
      };
    };
  };

  home.packages = [
    pkgs.scrot
    pkgs.slop
    pkgs.xdg-utils
  ];

  services.autorandr.enable = true;

  xsession = {
    enable = true;
    windowManager.awesome.enable = true;
    profileExtra = ''
      autorandr --load ${osConfig.currentHostname}
    '';
  };

  xresources = {
    path = "${config.xdg.configHome}/X11/xresources";
    properties = {
      "Xft.dpi" = 192;
    };
  };

  xdg.configFile = {
    awesome = {
      source = ./awesome;
      recursive = true;
    };
    "awesome/scripts/dunst-sound.sh" = {
      executable = true;
      text = ''
        #!${pkgs.coreutils-full}/bin/env ${pkgs.bash}/bin/bash
      '' + (builtins.readFile ./awesome/scripts.tmpl/dunst-sound.sh);
    };
    "awesome/scripts/pavolume.sh" = {
      executable = true;
      text = ''
        #!${pkgs.coreutils-full}/bin/env ${pkgs.bash}/bin/bash
      '' + (builtins.readFile ./awesome/scripts.tmpl/pavolume.sh);
    };
    "awesome/autorun.sh" = {
      executable = true;
      text = ''
        #!${pkgs.coreutils-full}/bin/env ${pkgs.bash}/bin/bash

        run() {
          if ! pgrep -f "$(basename "$1")"; then
            "$@" &
          fi
        }

        run ${pkgs.obsidian}/bin/obsidian
        run ${pkgs.syncthingtray-minimal}/bin/syncthingtray --wait
        run ${pkgs.discord}/bin/discord
        run ${pkgs.whatsapp-for-linux}/bin/whatsapp-for-linux
        run ${pkgs.slack}/bin/slack
        run ${pkgs.telegram-desktop}/bin/telegram-desktop
        run ${pkgs.thunderbird-128}/bin/thunderbird
        run ${pkgs.ungoogled-chromium}/bin/chromium --app="https://teams.microsoft.com/" --class="teams-pwa" --user-data-dir="${config.xdg.stateHome}/teams"
        run ${pkgs.caffeine-ng}/bin/caffeine
        ${pkgs.betterlockscreen}/bin/betterlockscreen -u ${config.xdg.dataHome}/wallpapers --fx dimpixel
      '';
    };
  };
  xdg.dataFile = {
    wallpapers = {
      source = ./wallpapers;
      recursive = true;
    };
  };
}

