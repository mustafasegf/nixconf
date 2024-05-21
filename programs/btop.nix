{ config
, pkgs
, libs
, ...
}: {
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "dracula";
      theme_background = false;
      truecolor = true;
      force_tty = false;
      presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";

      vim_keys = false;
      rounded_corners = true;
      graph_symbol = "braille";
      shown_boxes = "mem net proc cpu";
      update_ms = 250;
      proc_sorting = "cpu lazy";
      proc_reversed = false;
      proc_tree = false;
      proc_colors = true;
      proc_gradient = false;
      proc_per_core = true;
      proc_mem_bytes = true;
      proc_cpu_graphs = true;
      proc_info_smaps = false;
      proc_left = true;
      proc_filter_kernel = false;
      cpu_graph_upper = "total";
      cpu_graph_lower = "user";
      cpu_invert_lower = true;
      cpu_single_graph = false;
      cpu_bottom = false;
      show_uptime = true;
      check_temp = true;
      cpu_sensor = "Auto";
      show_coretemp = true;
      cpu_core_map = "";
      temp_scale = "celsius";
      show_swap = false;
    };
  };
}
