{ config, ... }:
{
  programs.niri.settings.animations = {
    # 窗口打开动画
    window-open = {
      kind.spring = {
        damping-ratio = 0.7;
        stiffness = 300;
        epsilon = 0.001;
      };
    };

    # 窗口关闭动画 - 火焰效果
    window-close = {
      kind.easing = {
        curve = "ease-out-quad";
        duration-ms = 1000;
      };
      custom-shader = let
        inherit (config.lib.stylix.colors.withHashtag) base00 base05 base08 base09 base0A;
      in ''
        // 简化版火焰效果
        vec4 close_color(vec3 coords_geo, vec3 size_geo) {
          vec2 uv = coords_geo.st;
          
          // 获取窗口纹理
          vec3 coords_tex = niri_geo_to_tex * coords_geo;
          vec4 color = texture2D(niri_tex, coords_tex.st);
          
          // 简单淡出效果
          float progress = niri_progress;
          color.a *= (1.0 - progress);
          
          return color;
        }
      '';
    };

    # 工作区切换动画
    workspace-switch = {
      kind.spring = {
        damping-ratio = 0.8;
        stiffness = 600;
        epsilon = 0.001;
      };
    };

    # 窗口移动动画
    window-movement = {
      kind.spring = {
        damping-ratio = 1.0;
        stiffness = 600;
        epsilon = 0.001;
      };
    };

    # 水平视图移动
    horizontal-view-movement = {
      kind.spring = {
        damping-ratio = 1.0;
        stiffness = 600;
        epsilon = 0.001;
      };
    };
  };
}
