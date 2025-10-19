# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  # programs.niri.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
  nix.settings.auto-optimise-store = true;

  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true;

  hardware.graphics.enable = true;
  hardware.nvidia.open = true;
  hardware.nvidia.modesetting.enable = true;

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
      };
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";  
  };

  virtualisation.docker.enable = true;

  services.xserver.videoDrivers = ["modesetting" "nvidia"];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = ["hid_apple.fnmode=2"];

  boot = {
    extraModulePackages = with config.boot.kernelPackages;
    [v4l2loopback];
    extraModprobeConfig = ''options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1 '';
  };

  networking.hostName = "Scil-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = ["Mihomo"];
    checkReversePath = false;
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [fcitx5-gtk fcitx5-chinese-addons];
    # fcitx5.waylandFrontend = true;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "cn";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.scil = {
    isNormalUser = true;
    description = "scil";
    extraGroups = [ "networkmanager" "wheel" "docker" "gamemode"];
  };

  # Enable automatic login for the user.
  # services.displayManager.autoLogin.enable = true;
  # services.displayManager.autoLogin.user = "scil";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  # systemd.services."getty@tty1".enable = false;
  # systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = ["ventoy-qt5-1.1.07"];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    neovim
    git
    gnupg
    wget
    nvtopPackages.nvidia
    noto-fonts
    fira-code
    lshw
    asusctl
    wineWowPackages.waylandFull
    winetricks
    blesh
    xsettingsd
    pinentry
    
    (writeShellScriptBin "nvidia-offload" ''
      #!/usr/bin/env bash
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-GO
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec "$@"
    '')

  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  # services = {
  #   desktopManager.plasma6.enable = true;
  #   displayManager.sddm = {
  #     enable = true;
  #     theme = "chili";
  #     wayland.enable = true;
  #     enableHidpi = true;
  #     autoNumlock = true;
  #     settings = {
  #       CompositorCommand = {
  #         Exec = "kwin_wayland --drm --no-lockscreen --no-global-shortcuts --locale1";
  #         };
  #       };
  #     };
  #   };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "scil";
        command = 
          # "${pkgs.greetd.tuigreet}/bin/tuigreet --time --asterisks --remember --remember-session --sessions --cmd ${pkgs.niri}/bin/niri";
          "${pkgs.niri}/bin/niri";
      };
    };
  };
 
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce;[thunar-volman thunar-archive-plugin];
  };
  security.soteria.enable = true;
  services.gvfs.enable = true;

  programs.xwayland.enable = true;
  programs.kdeconnect.enable = true;
  programs.clash-verge.enable = true;	
  programs.clash-verge.autoStart = true;
  programs.clash-verge.serviceMode = true;
  programs.gamemode.enable = true;
  # programs.kde-pim = {
  #   enable = true;
  #   kmail = true;
  #   kontact = true;
  #   };  

  # 确保 doas 配置正确
  security.doas = {
    enable = true;
    extraRules = [{
      users = [ "scil" ];
      noPass = true;
      keepEnv = true;
    }];
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    package = pkgs.steam.override {
      extraPkgs = p:[p.kdePackages.breeze];
      };
  };

  services.asusd.enable = true;
  services.fwupd.enable = true;
  services.ollama = {
    enable = true;
    loadModels = ["gpt-oss:20b" "deepseek-r1:32b" "gemma3:27b"];
    acceleration = "cuda";
  };
  services.ratbagd.enable = true;

  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      wqy_zenhei
      hack-font
      source-code-pro
      jetbrains-mono
      lxgw-wenkai
      cascadia-code
    ];

    fontconfig = {
      antialias = true;
      hinting.enable = true;
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = ["lxgw-wenkai" "Noto Sans CJK SC" "DejaVu Sans Mono"];
        sansSerif = ["lxgw-wenkai" "Noto Sans CJK SC" "DejaVu Sans"];
        serif = ["lxgw-wenkai" "Noto Sans CJK SC" "DejaVu Serif"];
      };
    };
  };















}
