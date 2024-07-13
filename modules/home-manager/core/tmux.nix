{ pkgs, ... }: {
  programs.tmux = {
    baseIndex = 1;
    enable = true;
    escapeTime = 100;
    keyMode = "vi";
    mouse = false;
    newSession = true;
    shell = "${pkgs.zsh}/bin/zsh";
    shortcut = "a";
    terminal = "screen-256color";

    plugins = [
      {
        # catppuccin must go first
        plugin = pkgs.tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour "mocha"

          set -g @catppuccin_window_left_separator "█"
          set -g @catppuccin_window_right_separator "█ "
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_middle_separator "  █"

          set -g @catppuccin_status_modules "battery session date_time" # for backwards compatibility
          set -g @catppuccin_status_modules_right "battery session date_time"

          set -g @catppuccin_status_left_separator  ""
          set -g @catppuccin_status_right_separator " "
          set -g @catppuccin_status_right_separator_inverse "yes"
          set -g @catppuccin_status_fill "all"
          set -g @catppuccin_status_connect_separator "no"

          set -g @catppuccin_date_time_text "%H:%M"
        '';
      }
      pkgs.tmuxPlugins.battery
    ];

    extraConfig = ''
      set-option -g focus-events on
      set-option -sa terminal-features ",xterm-256color:RGB"

      # window splitting
      unbind %
      bind | split-window -h
      unbind '"'
      bind - split-window -v

      set -g status-position top
    '';
  };
}
