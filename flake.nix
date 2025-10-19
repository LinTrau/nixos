{
  description = "ROG Flake";

  nixConfig.extra-experimental-features = ["flake" "nix-command" "pipe-operators"];

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:nix-community/stylix";
    nil.url = "github:oxalica/nil";
    nixd.url = "github:nix-community/nixd";
    nh.url = "github:nix-community/nh";
    agenix.url = "github:ryantm/agenix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    mangowc.url = "github:DreamMaoMao/mangowc";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    nix-matlab = {
      url = "gitlab:doronbehar/nix-matlab";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty.url = "github:ghostty-org/ghostty";
    nixGL.url = "github:nix-community/nixGL";

    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.quickshell.follows = "quickshell";
    };

    niri-caelestia-shell = {
      url = "github:jutraim/niri-caelestia-shell";
      inputs.quickshell.follows = "quickshell";
    };

    caelestia-cli.url = "github:caelestia-dots/cli";
    noctalia-shell = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.quickshell.follows = "quickshell";
    };
    hexecute.url = "github:ThatOtherAndrew/Hexecute";
  };

  outputs = inputs @ { self, flake-parts, ... }:
    flake-parts.lib.mkFlake {
      inherit inputs;
    } {
      systems = [ "x86_64-linux" ];

      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem = { pkgs, ... }: {
        treefmt = {
          projectRootFile = "flake.nix";
          programs.nixfmt.enable = true;
          programs.ruff-format.enable = true;
          programs.prettier.enable = true;
          programs.beautysh.enable = true;
          programs.toml-sort.enable = true;
          settings.global.excludes = [ "*.age" ];
          settings.formatter = {
            jsonc = {
              command = "${pkgs.nodePackages.prettier}/bin/prettier";
              includes = [ "*.jsonc" ];
            };
            scripts = {
              command = "${pkgs.beautysh}/bin/beautysh";
              includes = [ "*/scripts/*" ];
            };
          };
        };
      };

      flake = {
        homeManagerModules = import ./modules/home-manager;
        overlays = import ./overlays { inherit inputs self; };
        templates = import ./templates;

        nixosConfigurations = {
          "Scil-nixos" = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./configuration.nix
              
              # Niri 和 Stylix 模块
              inputs.stylix.nixosModules.stylix
              # inputs.niri.nixosModules.niri
              # Home Manager 配置
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.scil = import ./home.nix;
                home-manager.backupFileExtension = "bak";
                
                # 传递 inputs 给 home-manager
                home-manager.extraSpecialArgs = { inherit inputs; };
                
                # Home Manager 的共享模块
                home-manager.sharedModules = [
                  inputs.niri.homeModules.niri
                  inputs.stylix.homeModules.stylix
                ];
              }
              
              # Zen Browser
              ({ pkgs, ... }: {
                environment.systemPackages = [ 
                  inputs.zen-browser.packages."x86_64-linux".twilight 
                ];
              })
              
              # NUR
              inputs.nur.modules.nixos.default
              ({ pkgs, ... }: {
                fonts.packages = [
                  pkgs.nur.repos.rewine.ttf-wps-fonts
                  pkgs.nur.repos.rewine.ttf-ms-win10
                ];
              })
            ];
          };
        };
      };
    };
}
