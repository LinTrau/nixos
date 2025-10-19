{ config, pkgs, inputs, lib, ... }:
{
  home.username = "scil";
  home.homeDirectory = "/home/scil";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  # 导入 niri 配置
  imports = [
    (import ./niri )
  ];

  home.packages = with pkgs; [
    # 基础工具
    fastfetch
    piper
    
    # 应用程序
    qq
    wechat
    obs-studio
    vscode
    mpv
    libreoffice-qt6-fresh
    projectlibre
    telegram-desktop
    tmux
    gimp	
    prismlauncher
    osu-lazer-bin
    adwsteamgtk	
    ventoy-full-qt

    # KDE 工具
    kdePackages.spectacle
    okteta
    supergfxctl-plasmoid

    # Wayland 工具
    mako
    alacritty
    waybar
    hyprlock
    swaybg
    uwsm
    wlsunset
    fuzzel
    xwayland-satellite
    file-roller
    
    # 截图和剪贴板工具
    grim
    slurp
    wl-clipboard
    
    # 亮度控制
    brightnessctl
    
    # 主题和图标
    adwaita-icon-theme
    gnome-themes-extra
    
    # 壁纸工具
    swww
    tofi
  ];

  # Git 配置
  programs.git = {
    enable = true;
    userName = "LinTrau";
    userEmail = "eddyjarnaginbzw15@gmail.com";
    signing.key = "";
    signing.signByDefault = true;
  };

  # 服务配置
  services = {
    avizo.enable = true;
    swaync.enable = true;
    wlsunset = {
      enable = false;  # 由 autostart 管理
    };
    mako = {
      enable = true;
      defaultTimeout = 5000;
    };
  };

  # 程序配置
  programs = {
    alacritty.enable = true;
    fuzzel.enable = true;
    tofi = {
      enable = true;
      settings = {
        width = "50%";
        height = "40%";
        border-width = 2;
        outline-width = 0;
        padding-left = "5%";
        padding-top = "5%";
        result-spacing = 25;
        num-results = 10;
        font = "DejaVu Sans Mono";
        background-color = pkgs.lib.mkForce "#1e1e2e";
        border-color = pkgs.lib.mkForce "#cba6f7";
        text-color = pkgs.lib.mkForce "#cdd6f4";
        prompt-text = "run: ";
        selection-color = pkgs.lib.mkForce "#cba6f7";
      };
    };
  };
  
  # 输入法配置
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-chinese-addons
    ];
  };
  
  # Stylix 配置
  stylix = {
    enable = true;
    image = ./image/image.jpg;
    polarity = "dark";
  };
}
