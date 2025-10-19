{ config, ... }:
let
  # 使用基础颜色
  colors = if (config ? stylix && config.stylix ? colors) then
    config.stylix.colors.withHashtag
  else {
    base00 = "#1e1e2e";
    base01 = "#181825";
    base02 = "#313244";
    base03 = "#45475a";
    base04 = "#585b70";
    base05 = "#cdd6f4";
    base06 = "#f5e0dc";
    base07 = "#b4befe";
    base08 = "#f38ba8";
    base09 = "#fab387";
    base0A = "#f9e2af";
    base0B = "#a6e3a1";
    base0C = "#94e2d5";
    base0D = "#89b4fa";
    base0E = "#cba6f7";
    base0F = "#f2cdcd";
  };

  inherit (colors) base00 base01 base04 base05 base06 base07 base08 base0A base0B base0D base0E base0F;

  moduleConfiguration = ''
    "niri/workspaces": {
      "format": "{icon}",
      "format-icons": {
        "default": ""
      }
    },
    "niri/window": {
      "format": "{}",
      "separate-outputs": true,
      "icon": true,
      "icon-size": 18,
      "max-length": 50
    },
    "memory": {
      "interval": 30,
      "format": "<span foreground='#${base0E}'>  </span>  {used:0.1f}G/{total:0.1f}G",
      "on-click": "alacritty -e htop"
    },
    "backlight": {
      "device": "intel_backlight",
      "on-scroll-up": "brightnessctl set +5%",
      "on-scroll-down": "brightnessctl set 5%-",
      "format": "<span size='13000' foreground='#${base0D}'>{icon} </span>  {percent}%",
      "format-icons": ["", ""]
    },
    "tray": {
      "icon-size": 16,
      "spacing": 10
    },
    "clock": {
      "format": "<span foreground='#${base0E}'>  </span>  {:%a %d %H:%M}",
      "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>"
    },
    "battery": {
      "states": {
        "warning": 30,
        "critical": 15
      },
      "format": "<span size='13000' foreground='#${base0E}'>{icon}  </span>{capacity}%",
      "format-warning": "<span size='13000' foreground='#${base0E}'>{icon}  </span>{capacity}%",
      "format-critical": "<span size='13000' foreground='#${base08}'>{icon}  </span>{capacity}%",
      "format-charging": "<span size='13000' foreground='#${base0E}'>  </span>{capacity}%",
      "format-plugged": "<span size='13000' foreground='#${base0E}'>  </span>{capacity}%",
      "format-full": "<span size='13000' foreground='#${base0E}'>  </span>{capacity}%",
      "format-icons": ["", "", "", "", ""],
      "tooltip-format": "{time}",
      "interval": 5
    },
    "network": {
      "format-wifi": "<span size='13000' foreground='#${base06}'>  </span>{essid}",
      "format-ethernet": "<span size='13000' foreground='#${base06}'>  </span>有线连接",
      "format-disconnected": "<span size='13000' foreground='#${base06}'> </span>未连接",
      "tooltip-format-wifi": "信号强度: {signalStrength}%"
    },
    "pulseaudio": {
      "on-click": "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
      "on-scroll-up": "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+",
      "on-scroll-down": "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-",
      "format": "<span size='13000' foreground='#${base0A}'>{icon}  </span>{volume}%",
      "format-muted": "<span size='13000' foreground='#${base0A}'>  </span>静音",
      "format-icons": {
        "default": ["", "", "", ""]
      }
    }
  '';
  
  combinedCss = ''
    @define-color base00 #${colors.base00};
    @define-color base01 #${colors.base01};
    @define-color base04 #${colors.base04};
    @define-color base05 #${colors.base05};
    @define-color base06 #${colors.base06};
    @define-color base07 #${colors.base07};
    @define-color base08 #${colors.base08};
    @define-color base0A #${colors.base0A};
    @define-color base0B #${colors.base0B};
    @define-color base0D #${colors.base0D};
    @define-color base0E #${colors.base0E};
    @define-color base0F #${colors.base0F};

    * {
      font-size: 14px;
      font-family: "Noto Sans CJK SC", "Fira Code", sans-serif;
      min-height: 0;
    }

    window#waybar {
      background: transparent;
    }

    tooltip {
      background: @base01;
      border-radius: 5px;
      border: 2px solid @base07;
    }

    #network,
    #clock,
    #battery,
    #pulseaudio,
    #workspaces,
    #backlight,
    #memory,
    #tray,
    #window {
      padding: 4px 10px;
      background: alpha(@base00, 0.9);
      color: @base05;
      margin: 10px 5px 5px 5px;
      box-shadow: 1px 2px 2px #101010;
      border-radius: 10px;
    }

    #workspaces {
      margin-left: 15px;
      padding: 6px 3px;
      border-radius: 20px;
    }

    #workspaces button {
      background-color: @base07;
      padding: 0px 5px;
      margin: 0px 4px;
      border-radius: 20px;
      min-width: 20px;
      transition: all 0.3s ease;
    }

    #workspaces button.active {
      background-color: @base0E;
      min-width: 30px;
    }

    #workspaces button:hover {
      background-color: @base0D;
    }

    #window {
      color: @base00;
      background: @base05;
      font-weight: bold;
    }

    window#waybar.empty #window {
      background: transparent;
      box-shadow: none;
    }
  '';
in
{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;  # 改为 false，使用 niri 的 spawn-at-startup
    };
    settings = [{
      position = "top";
      layer = "top";
      height = 40;
      margin-top = 5;
      margin-left = 10;
      margin-right = 10;
      "modules-left" = [
        "niri/workspaces"
        "niri/window"
      ];
      "modules-center" = [
        "clock"
      ];
      "modules-right" = [
        "tray"
        "memory"
        "network"
        "pulseaudio"
        "backlight"
        "battery"
      ];
    }
    (builtins.fromJSON ("{ ${moduleConfiguration} }"))];
    style = combinedCss;
  };
  
  # 通过 niri 启动 waybar
  programs.niri.settings.spawn-at-startup = [
    { command = ["waybar"]; }
  ];
}
