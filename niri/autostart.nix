{ pkgs, user, ... }:
let
  niri-autostart = pkgs.writeShellApplication {
    name = "niri-autostart";
    runtimeInputs = with pkgs; [
      swww
      wlsunset
      systemd
      killall
      coreutils
    ];
    text = ''
      # 等待 Wayland 会话准备好
      sleep 2
      
      # 壁纸守护进程
      killall swww-daemon 2>/dev/null || true
      swww-daemon &
      sleep 2
      
      # 设置默认壁纸（如果没有保存的壁纸）
      if [ -f ~/.cache/swww/current ]; then
        swww img "$(cat ~/.cache/swww/current)" --transition-type fade --transition-duration 2
      else
        # 使用 stylix 的壁纸作为默认
        if [ -f ~/Pictures/Wallpapers/default.jpg ]; then
          swww img ~/Pictures/Wallpapers/default.jpg --transition-type fade --transition-duration 2
          echo ~/Pictures/Wallpapers/default.jpg > ~/.cache/swww/current
        fi
      fi
      
      # 色温调整
      killall wlsunset 2>/dev/null || true
      wlsunset -t 4500 -T 6500 &
      
      # 输入法
      killall fcitx5 2>/dev/null || true
      fcitx5 -d -r &
      
      # 系统托盘应用
      nm-applet --indicator &
      blueman-applet &
      
      # 通知守护进程
      killall mako 2>/dev/null || true
      mako &
    '';
  };
in
{
  programs.niri.settings.spawn-at-startup = [
    { command = ["${niri-autostart}/bin/niri-autostart"]; }
  ];
  
  home.packages = [ niri-autostart ];
  
  # 确保必要的目录存在
  home.file.".cache/swww/.keep".text = "";
  home.file."Pictures/Wallpapers/.keep".text = "";
}
