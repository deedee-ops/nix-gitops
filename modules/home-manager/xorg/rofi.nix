{ pkgs, config, osConfig, lib, ... }:
let
  pinentryRofi = pkgs.writeShellApplication {
    name = "pinentry-rofi-with-env";
    text = ''
      PATH="$PATH:${pkgs.coreutils-full}/bin:${pkgs.rofi}/bin"
      "${pkgs.pinentry-rofi}/bin/pinentry-rofi" "$@" -- -theme ${config.xdg.configHome}/rofi/pinentry/config.rasi
    '';
    meta = {
      mainProgram = "pinentry-rofi-with-env";
    };
  };
in
{
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

  services.gpg-agent = {
    pinentryPackage = lib.mkForce pinentryRofi;
  };

  xdg.configFile = {
    rofi = {
      source = ./rofi;
      recursive = true;
    };
    "rofi/powermenu/powermenu.sh" = {
      executable = true;
      text = ''
        #!${pkgs.coreutils-full}/bin/env ${pkgs.bash}/bin/bash
      '' + (builtins.readFile ./rofi/powermenu/powermenu.sh.tmpl);
    };
    "rofi/todo/todo.sh" = {
      executable = true;
      text = ''
        #!${pkgs.coreutils-full}/bin/env ${pkgs.bash}/bin/bash

        if [ -n "$*" ]; then
          ${pkgs.curl}/bin/curl -s -o /dev/null -k --header "Content-Type: application/json" \
          --request POST \
          --data "{\"title\": \"$*\" }" \
          "https://localhost:11111/api/items?key=$(cat ${config.sops.secrets."everdo/apikey".path})"
        fi
      '';
    };
    "rofi/window/focus-window.sh" = {
      executable = true;
      text = ''
        #!${pkgs.coreutils-full}/bin/env ${pkgs.bash}/bin/bash

        echo "
        for _, c in ipairs(client.get()) do
          if c.window == $1 then
            c:tags()[1]:view_only()
            client.focus = c
            c:raise()
          end
        end
        " | ${pkgs.awesome}/bin/awesome-client
      '';
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
