{ pkgs, config, ... }: {
  home.packages = [ pkgs.libnotify ];
  services.dunst = {
    enable = true;

    settings = {
      experiments = {
        per_monitor_dpi = "no";
      };

      global = {
        # theme
        frame_color = "#89B4FA";
        separator_color = "frame";
        default_icon = "~/.config/dunst/default.png";
        icon_corner_radius = 0;
        frame_width = 3;
        corner_radius = 6;

        alignment = "left";
        always_run_script = true;
        browser = "firefox";
        class = "Dunst";
        dmenu = "dmenu -i -p Dunst:";
        follow = "mouse";
        font = "JetBrainsMono Nerd Font Mono 10";
        force_xinerama = false;
        format = "<b>%s</b>\n%b";
        hide_duplicate_count = false;
        history_length = 50;
        horizontal_padding = 10;
        icon_position = "left";
        idle_threshold = 120;
        ignore_newline = false;
        indicate_hidden = true;
        line_height = 5;
        markup = "full";
        max_icon_size = 64;
        monitor = 0;
        notification_height = 75;
        padding = 16;
        separator_height = 2;
        show_age_threshold = 60;
        show_indicators = true;
        shrink = false;
        sort = true;
        stack_duplicates = true;
        startup_notification = false;
        sticky_history = true;
        title = "Dunst";
        transparency = 0;
        word_wrap = true;

        # persistent
        timeout = 0;
        set_transient = false;
        ignore_dbusclose = true;

        # play sound
        script = "${config.xdg.configHome}/dunst/play-sound.sh";

        # geometry
        width = "(300, 500)";
        height = 175;
        origin = "top-right";
        notification_limit = 20;
        offset = "10x25";

        #shortcuts
        history = "ctrl+grave"; # ctrl+tilde
      };

      urgency_critical = {
        background = "#1E1E2E";
        foreground = "#CDD6F4";
        frame_color = "#FAB387";
      };

      urgency_normal = {
        background = "#1E1E2E";
        foreground = "#CDD6F4";
      };

      urgency_low = {
        background = "#1E1E2E";
        foreground = "#CDD6F4";
      };
    };
  };

  xdg.configFile = {
    "dunst/play-sound.sh" = {
      executable = true;
      text = ''
        #!${pkgs.coreutils-full}/bin/env ${pkgs.bash}/bin/bash
      '' + (builtins.readFile ./dunst/play-sound.sh);
    };
  };
}
