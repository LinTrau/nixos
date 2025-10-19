{ config, pkgs, user, lib, inputs, ... }:
{
  imports = [
   #  inputs.niri.homeModules.niri
    ./animations.nix
    ./waybar.nix
    ./autostart.nix
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri.overrideAttrs (old: {doCheck = false; });

    settings = with config.lib.stylix.colors.withHashtag; {
      hotkey-overlay.skip-at-startup = true;
      prefer-no-csd = true;
      
      input = {
        focus-follows-mouse.enable = true;
        touchpad.natural-scroll = false;
        keyboard.xkb.options = "caps:escape";
      };

      environment = {
        DISPLAY = ":0";
        XIM = "fcitx";
        GTK_IM_MODULE = "fcitx";
        QT_IM_MODULE = "fcitx";
      };

      # 输出配置
      outputs = {
        "eDP-1" = {
          scale = 1.6;
          mode = {
            width = 2560;
            height = 1200;
            refresh = 240.0;
          };
          position = { x = 0; y = 0; };
          transform.rotation = 0;
        };
      };

      # 完整的快捷键配置（默认 + 自定义）
      binds = with config.lib.niri.actions; {
        # 基础应用启动
        "Mod+Return".action = spawn "alacritty";
        "Mod+D".action = spawn "tofi-run";
        "Mod+Q".action = close-window;
        
        # 焦点切换（方向键）
        "Mod+Left".action = focus-column-left;
        "Mod+Right".action = focus-column-right;
        "Mod+Down".action = focus-window-down;
        "Mod+Up".action = focus-window-up;
        
        # 焦点切换（vim 键位）
        "Mod+H".action = focus-column-left;
        "Mod+L".action = focus-column-right;
        "Mod+J".action = focus-window-down;
        "Mod+K".action = focus-window-up;
        
        # 窗口移动（方向键）
        "Mod+Shift+Left".action = move-column-left;
        "Mod+Shift+Right".action = move-column-right;
        "Mod+Shift+Down".action = move-window-down;
        "Mod+Shift+Up".action = move-window-up;
        
        # 窗口移动（vim 键位）
        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+L".action = move-column-right;
        "Mod+Shift+J".action = move-window-down;
        "Mod+Shift+K".action = move-window-up;
        
        # 跨显示器焦点切换
        "Mod+Ctrl+Left".action = focus-monitor-left;
        "Mod+Ctrl+Right".action = focus-monitor-right;
        "Mod+Ctrl+Down".action = focus-monitor-down;
        "Mod+Ctrl+Up".action = focus-monitor-up;
        
        "Mod+Ctrl+H".action = focus-monitor-left;
        "Mod+Ctrl+L".action = focus-monitor-right;
        "Mod+Ctrl+J".action = focus-monitor-down;
        "Mod+Ctrl+K".action = focus-monitor-up;
        
        # 跨显示器窗口移动
        "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;
        "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
        
        "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;
        "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
        
        # 工作区切换（数字键）
        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+6".action = focus-workspace 6;
        "Mod+7".action = focus-workspace 7;
        "Mod+8".action = focus-workspace 8;
        "Mod+9".action = focus-workspace 9;
        
        # 移动窗口到工作区
        "Mod+Shift+1".action = spawn "niri msg action move-window-to-workspace 1";
        "Mod+Shift+2".action = spawn "niri msg action move-window-to-workspace 2";
        "Mod+Shift+3".action = spawn "niri msg action move-window-to-workspace 3";
        "Mod+Shift+4".action = spawn "niri msg action move-window-to-workspace 4";
        "Mod+Shift+5".action = spawn "niri msg action move-window-to-workspace 5";
        "Mod+Shift+6".action = spawn "niri msg action move-window-to-workspace 6";
        "Mod+Shift+7".action = spawn "niri msg action move-window-to-workspace 7";
        "Mod+Shift+8".action = spawn "niri msg action move-window-to-workspace 8";
        "Mod+Shift+9".action = spawn "niri msg action move-window-to-workspace 9";

        # 工作区上下切换
        "Mod+Page_Down".action = focus-workspace-down;
        "Mod+Page_Up".action = focus-workspace-up;
        "Mod+U".action = focus-workspace-down;
        "Mod+I".action = focus-workspace-up;
        
        # 窗口移动到上下工作区
        "Mod+Shift+Page_Down".action = spawn "niri msg action move-window-to-workspace down";
        "Mod+Shift+Page_Up".action = spawn "niri msg action move-window-to-workspace up";
        "Mod+Shift+U".action = spawn "niri msg action move-window-to-workspace down";
        "Mod+Shift+I".action = spawn "niri msg action move-window-to-workspace uo";
        
        # 窗口状态控制
        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+C".action = center-column;
        
        # 浮动窗口
        "Mod+Space".action = toggle-window-floating;
        
        # 列宽和窗口高度调整
        "Mod+R".action = switch-preset-column-width;
        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Equal".action = set-column-width "+10%";
        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Equal".action = set-window-height "+10%";
        
        # 列操作
        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;
        
        # 截图
        "Print".action = spawn "sh" "-c" ''grim - | wl-copy'';
        "Ctrl+Print".action = spawn "sh" "-c" ''grim -g "$(slurp)" - | wl-copy'';
        "Alt+Print".action = spawn "sh" "-c" ''grim -g "$(swaymsg -t get_tree | jq -r '.. | select(.focused?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')" - | wl-copy'';
        
        # 系统控制
        "Mod+Shift+E".action = quit;
        "Mod+Shift+P".action = power-off-monitors;
        
        # 概览
        "Mod+Tab".action = switch-focus-between-floating-and-tiling;
        
        # 重新加载配置
        "Mod+Shift+R".action = spawn "sh" "-c" "niri msg action reload-config";
      };

      # 窗口规则
      window-rules = [
        {
          geometry-corner-radius = {
            bottom-left = 10.0;
            bottom-right = 10.0;
            top-left = 10.0;
            top-right = 10.0;
          };
          clip-to-geometry = true;
          draw-border-with-background = false;
        }
        {
          matches = [{ is-focused = true; }];
          opacity = 0.95;
        }
        {
          matches = [{ is-focused = false; }];
          opacity = 0.85;
        }
      ];

      # 布局配置
      layout = {
        gaps = 12;
        border = {
          enable = true;
          width = 4;
          active = {
            gradient = {
              from = base07;
              to = base0E;
              angle = 45;
              in' = "oklab";
            };
          };
          inactive.color = base02;
        };
        focus-ring.enable = false;
        struts = {
          left = 2;
          right = 2;
          top = 0;
          bottom = 2;
        };
      };

      # 工作区配置
      workspaces = {
        "1" = { name = "coding"; };
        "2" = { name = "browsing"; };
        "3" = { name = "reading"; };
        "4" = { name = "music"; };
      };

      xwayland-satellite = {
        enable = true;
        path = lib.getExe pkgs.xwayland-satellite;
      };
    };
  };
}
