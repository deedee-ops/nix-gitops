{ osConfig, pkgs, ... }:
{
  programs.btop = {
    enable = true;
    package = pkgs.btop.override { cudaSupport = osConfig.hardware.nvidia.modesetting.enable; };
    settings = {
      # general
      color_theme = "catppuccin_mocha.theme";
      theme_background = false;
      truecolor = true;
      force_tty = false;
      vim_keys = true;
      shown_boxes = "cpu mem net proc";
      update_ms = 2000;
      rounded_corners = true;
      graph_symbol = "braille";
      clock_format = "%X";
      base_10_sizes = false;
      background_update = true;
      show_battery = true;
      selected_battery = "Auto";
      show_battery_watts = true;
      log_level = "WARNING";

      # cpu
      cpu_bottom = false;
      graph_symbol_cpu = "default";
      cpu_graph_upper = "user";
      cpu_graph_lower = "total";
      cpu_invert_lower = false;
      cpu_single_graph = false;
      show_gpu_info = "On";
      check_temp = true;
      cpu_sensor = "Auto";
      show_coretemp = true;
      temp_scale = "celsius";
      show_cpu_freq = true;
      custom_cpu_name = "";
      show_uptime = true;

      # gpu
      nvml_measure_pcie_speeds = true;
      graph_symbol_gpu = "default";
      gpu_mirror_graph = true;

      # mem
      mem_below_net = false;
      graph_symbol_mem = "default";
      mem_graphs = false;
      show_disks = true;
      show_io_stat = true;
      io_mode = false;
      io_graph_combined = false;
      io_graph_speeds = "";
      show_swap = false;
      swap_disk = true;
      only_physical = true;
      use_fstab = true;
      zfs_hide_datasets = false;
      disk_free_priv = false;
      disks_filter = "";
      zfs_arc_cached = true;

      # net
      graph_symbol_net = "default";
      net_download = 100;
      net_upload = 100;
      net_auto = true;
      net_sync = true;
      net_iface = "";

      # proc
      proc_left = false;
      graph_symbol_proc = "default";
      proc_sorting = "cpu direct";
      proc_reversed = false;
      proc_tree = false;
      proc_aggregate = false;
      proc_colors = true;
      proc_gradient = true;
      proc_per_core = false;
      proc_mem_bytes = true;
      proc_cpu_graphs = false;
      proc_filter_kernel = true;
      proc_info_smaps = false;
    };
  };

  xdg.configFile."btop/themes/catppuccin_mocha.theme".text = ''
    # Main background, empty for terminal default, need to be empty if you want transparent background
    theme[main_bg]="#1e1e2e"

    # Main text color
    theme[main_fg]="#cdd6f4"

    # Title color for boxes
    theme[title]="#cdd6f4"

    # Highlight color for keyboard shortcuts
    theme[hi_fg]="#89b4fa"

    # Background color of selected item in processes box
    theme[selected_bg]="#45475a"

    # Foreground color of selected item in processes box
    theme[selected_fg]="#89b4fa"

    # Color of inactive/disabled text
    theme[inactive_fg]="#7f849c"

    # Color of text appearing on top of graphs, i.e uptime and current network graph scaling
    theme[graph_text]="#f5e0dc"

    # Background color of the percentage meters
    theme[meter_bg]="#45475a"

    # Misc colors for processes box including mini cpu graphs, details memory graph and details status text
    theme[proc_misc]="#f5e0dc"

    # CPU, Memory, Network, Proc box outline colors
    theme[cpu_box]="#cba6f7" #Mauve
    theme[mem_box]="#a6e3a1" #Green
    theme[net_box]="#eba0ac" #Maroon
    theme[proc_box]="#89b4fa" #Blue

    # Box divider line and small boxes line color
    theme[div_line]="#6c7086"

    # Temperature graph color (Green -> Yellow -> Red)
    theme[temp_start]="#a6e3a1"
    theme[temp_mid]="#f9e2af"
    theme[temp_end]="#f38ba8"

    # CPU graph colors (Teal -> Lavender)
    theme[cpu_start]="#94e2d5"
    theme[cpu_mid]="#74c7ec"
    theme[cpu_end]="#b4befe"

    # Mem/Disk free meter (Mauve -> Lavender -> Blue)
    theme[free_start]="#cba6f7"
    theme[free_mid]="#b4befe"
    theme[free_end]="#89b4fa"

    # Mem/Disk cached meter (Sapphire -> Lavender)
    theme[cached_start]="#74c7ec"
    theme[cached_mid]="#89b4fa"
    theme[cached_end]="#b4befe"

    # Mem/Disk available meter (Peach -> Red)
    theme[available_start]="#fab387"
    theme[available_mid]="#eba0ac"
    theme[available_end]="#f38ba8"

    # Mem/Disk used meter (Green -> Sky)
    theme[used_start]="#a6e3a1"
    theme[used_mid]="#94e2d5"
    theme[used_end]="#89dceb"

    # Download graph colors (Peach -> Red)
    theme[download_start]="#fab387"
    theme[download_mid]="#eba0ac"
    theme[download_end]="#f38ba8"

    # Upload graph colors (Green -> Sky)
    theme[upload_start]="#a6e3a1"
    theme[upload_mid]="#94e2d5"
    theme[upload_end]="#89dceb"

    # Process box color gradient for threads, mem and cpu usage (Sapphire -> Mauve)
    theme[process_start]="#74c7ec"
    theme[process_mid]="#b4befe"
    theme[process_end]="#cba6f7"
  '';
}
