{ config
, pkgs
, libs
, ...
}: {
  programs.rofi = {
    enable = false;

    plugins = with pkgs; [
      rofi-calc
      rofi-emoji
      rofi-pass
      rofi-systemd
    ];
    font = "IBM Plex Mono 12";

    # theme = {
    #   "*" = {
    #     drac-bgd = "rgba (40, 42, 54, 50%)";
    #     drac-cur = "#44475a";
    #     drac-fgd = "#f8f8f2";
    #     drac-cmt = "#6272a4";
    #     drac-cya = "#8be9fd";
    #     drac-grn = "#50fa7b";
    #     drac-ora = "#ffb86c";
    #     drac-pnk = "rgba (255, 121, 198, 17% )";
    #     drac-pur = "#bd93f9";
    #     drac-red = "rgba (255, 85, 85, 17%)";
    #     drac-yel = "#f1fa8c";
    #
    #     foreground = "@drac-fgd";
    #     background-color = "@drac-bgd";
    #     active-background = "@drac-pnk";
    #     urgent-background = "@drac-red";
    #
    #     selected-background = "@active-background";
    #     selected-urgent-background = "@urgent-background";
    #     selected-active-background = "@active-background";
    #     separatorcolor = "@active-background";
    #     bordercolor = "#6272a4";
    #   };
    #
    #   "#window" = {
    #     background-color = "@background-color";
    #     border = 1;
    #     border-radius = 6;
    #     border-color = "@bordercolor";
    #   };
    #
    #   "#mainbox" = {
    #     border = 0;
    #     padding = 5;
    #   };
    #   "#message" = {
    #     border = "0px dash 0px 0px ";
    #     border-color = "@separatorcolor";
    #     padding = "0px ";
    #   };
    #   "#textbox" = {
    #     text-color = "@foreground";
    #   };
    #   "#listview" = {
    #     lines = 10;
    #     columns = 3;
    #     fixed-height = 0;
    #     border = "2px dash 0px 0px ";
    #     border-color = "@bordercolor";
    #     spacing = "0px ";
    #     scrollbar = true;
    #     padding = "2px 0px 0px ";
    #   };
    #   "#element" = {
    #     border = 0;
    #     padding = "1px ";
    #   };
    #   "#element.normal.normal" = {
    #     background-color = "@background-color";
    #     text-color = "@foreground";
    #   };
    #   "#element.normal.urgent" = {
    #     background-color = "@urgent-background";
    #     text-color = "@urgent-foreground";
    #   };
    #   "#element.normal.active" = {
    #     background-color = "@active-background";
    #     text-color = "@background-color";
    #   };
    #   "#element.selected.normal" = {
    #     background-color = "@selected-background";
    #     text-color = "@foreground";
    #   };
    #   "#element.selected.urgent" = {
    #     background-color = "@selected-urgent-background";
    #     text-color = "@foreground";
    #   };
    #   "#element.selected.active" = {
    #     background-color = "@selected-active-background";
    #     text-color = "@background-color";
    #   };
    #   "#element.alternate.normal" = {
    #     background-color = "@background-color";
    #     text-color = "@foreground";
    #   };
    #   "#element.alternate.urgent" = {
    #     background-color = "@urgent-background";
    #     text-color = "@foreground";
    #   };
    #   "#element.alternate.active" = {
    #     background-color = "@active-background";
    #     text-color = "@foreground";
    #   };
    #   "#scrollbar" = {
    #     width = "1px ";
    #     border = 0;
    #     handle-width = "4px ";
    #     padding = 0;
    #   };
    #   "#sidebar" = {
    #     border = "2px dash 0px 0px ";
    #     border-color = "@separatorcolor";
    #   };
    #   "#button.selected" = {
    #     background-color = "@selected-background";
    #     text-color = "@foreground";
    #   };
    #   "#inputbar" = {
    #     spacing = 0;
    #     text-color = "@foreground";
    #     padding = "1px ";
    #   };
    #   "#case-indicator" = {
    #     spacing = 0;
    #     text-color = "@foreground";
    #   };
    #   "#entry" = {
    #     spacing = 0;
    #     text-color = "@drac-cya";
    #   };
    #   "#prompt" = {
    #     spacing = 0;
    #     text-color = "@drac-grn";
    #   };
    #   "#inputbar" = {
    #     children = "[ prompt,textbox-prompt-colon,entry,case-indicator ]";
    #   };
    #   "#textbox-prompt-colon" = {
    #     expand = false;
    #     str = ":";
    #     margin = "0px 0.3em 0em 0em ";
    #     text-color = "@drac-grn";
    #   };
    #   "element-text, element-icon" = {
    #     background-color = "inherit";
    #     text-color = "inherit";
    #   };
    # };
    extraConfig = {
      show-icons = true;
      icon-theme = "Arc-X-D";
      display-drun = "Apps";
      drun-display-format = "{name}";
      scroll-method = 0;
      disable-history = false;
      sidebar-mode = false;
    };
  };
}
