{ pkgs, config, osConfig, lib, ... }: {
  home = {
    packages = [
      pkgs.haskellPackages.greenclip
      pkgs.msmtp
      pkgs.rofi-rbw
      pkgs.xdotool
    ];

    activation = {
      greenclip = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD mkdir -p ${config.xdg.cacheHome}/greenclip || true
      '';
      rofi = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD ${pkgs.fontconfig}/bin/fc-cache
      '';
    };
  };

  programs.rbw = {
    enable = true;
    settings = {
      email = "ajgon@${osConfig.remoteDomain}";
      base_url = "https://vaultwarden.${osConfig.remoteDomain}/";
      lock_timeout = 14400; # 4h
      pinentry = pkgs.pinentry-gtk2;
    };
  };

  programs.rofi = {
    enable = true;
  };

  xdg.configFile = {
    rofi = {
      source = ./rofi;
      recursive = true;
    };
    "rofi/pinentry/pinentry" = {
      executable = true;
      text = ''
        #!${pkgs.coreutils-full}/bin/env ${pkgs.bash}/bin/bash
        # hacky workaround to make pinentry-rofi use proper theme

        SCRIPT_DIR=$( cd -- "$( dirname -- "''${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

        export PATH="''${SCRIPT_DIR}:''${PATH}}"

        pinentry-rofi $*
      '';
    };
    "rofi/pinentry/rofi" = {
      executable = true;
      text = ''
        #!${pkgs.coreutils-full}/bin/env ${pkgs.bash}/bin/bash

        SCRIPT_DIR=$( cd -- "$( dirname -- "''${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

        export PATH="$(echo $PATH | sed 's@[^:]*:@@')" # remove hacky rofi from path to avoid infinite loop

        rofi -theme ''${SCRIPT_DIR}/config.rasi $*
      '';
    };
    "rofi/powermenu/powermenu.sh" = {
      executable = true;
      text = ''
        #!${pkgs.coreutils-full}/bin/env ${pkgs.bash}/bin/bash
      '' + (builtins.readFile ./rofi/powermenu/powermenu.sh.tmpl);
    };
    "greenclip.toml" = {
      text = ''
        [greenclip]
          blacklisted_applications = []
          enable_image_support = true
          history_file = "${config.xdg.cacheHome}/greenclip/history"
          image_cache_directory = "${config.xdg.cacheHome}/greenclip/image"
          max_history_length = 500
          max_selection_size_bytes = 0
          static_history = []
          trim_space_from_selection = true
          use_primary_selection_as_input = false
      '';
    };
  };
  xdg.dataFile = {
    fonts = {
      source = ./rofi/fonts;
      recursive = true;
    };
  };

  systemd.user.services.greenclip = {
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Unit = {
      Description = "Greenclip clipboard manager";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.haskellPackages.greenclip}/bin/greenclip daemon";
      Restart = "always";
      RestartSec = 3;
    };
  };
}
