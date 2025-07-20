# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, pkgs-unstable, ... }:

let
  # This script allows for explicit Nvidia GPU usage when needed
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  #------------------------------------------------------------------------------
  # System Configuration
  #------------------------------------------------------------------------------
  time.timeZone = "Europe/Moscow";
  system.stateVersion = "24.05"; # Never change

  #------------------------------------------------------------------------------
  # Boot Configuration
  #------------------------------------------------------------------------------
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 30;
      };
      efi.canTouchEfiVariables = true;
    };
    # Load both AMD and Nvidia modules
    initrd.kernelModules = [ "amdgpu" ];
    kernelModules =
      [ "ideapad_laptop" "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    kernelParams = [ "kvm.enable_virt_at_load=0" ];
    # Blacklist nouveau to avoid conflicts with the proprietary Nvidia driver
    blacklistedKernelModules = [ "nouveau" ];
  };

  #------------------------------------------------------------------------------
  # Hardware Configuration
  #------------------------------------------------------------------------------
  hardware = {
    brillo.enable = true;

    # OpenGL support
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa
        amdvlk
        rocmPackages.clr.icd
        nvidia-vaapi-driver # For Nvidia video acceleration
      ];
      extraPackages32 = with pkgs.driversi686Linux; [ amdvlk ];
    };

    # Bluetooth configuration
    bluetooth = {
      enable = true;
      powerOnBoot = false; # Power-saving measure
    };

    # Nvidia configuration
    nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = true; # Enable power management
        finegrained = true; # Enable more aggressive power saving
      };
      open = false; # Use proprietary drivers for better CUDA support
      nvidiaSettings = true; # Enable Nvidia settings application
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        offload = {
          enable = true; # Enable on-demand mode
          enableOffloadCmd = true;
        };
        # Bus IDs for GPUs - verify these values match your hardware
        amdgpuBusId = "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  #------------------------------------------------------------------------------
  # Environment Configuration
  #------------------------------------------------------------------------------
  environment = {
    sessionVariables = {
      QT_QPA_PLATFORM = "wayland;xcb";
      NIXOS_OZONE_WL = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      # CUDA-related variables
      CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
      LD_LIBRARY_PATH =
        "${pkgs.cudaPackages.cudatoolkit}/lib:${pkgs.cudaPackages.cudnn}/lib";
    };

    # System packages
    systemPackages = with pkgs; [
      # GPU utilities
      nvidia-offload # Include nvidia-offload script
      clinfo
      lshw
      glxinfo
      vulkan-tools

      # CUDA and ML-related packages
      cudaPackages.cudatoolkit
      cudaPackages.cudnn
      linuxPackages.nvidia_x11

      # Terminal and editors
      kitty
      vim
      vifm
      neovim

      # Development tools
      pkg-config
      openssl
      git
      wget
      curl

      # Libraries and dependencies
      egl-wayland
      libsecret
      libxkbcommon
      libGL
      xorg.libX11
      xorg.libXcursor
      xorg.libXrandr
      xorg.libXi
      nss
      alsa-lib
      at-spi2-core
      glib
      curl
      openssl
      qt5.qtwayland
      qt5.full

      # Web development
      esbuild
      electron
      nodejs
      bun

      # Themes
      (catppuccin-sddm.override {
        flavor = "mocha";
        font = "Inter";
        fontSize = "15";
        loginBackground = false;
      })
    ];
  };

  #------------------------------------------------------------------------------
  # Networking Configuration
  #------------------------------------------------------------------------------
  networking = {
    hostName = "ideapad";
    networkmanager.enable = true;
    iproute2.enable = true;
    enableIPv6 = true;
    firewall = { allowedTCPPorts = [ 5432 5173 ]; };
    extraHosts = ''
      127.0.0.1 tma.internal
    '';
  };

  #------------------------------------------------------------------------------
  # Security Configuration
  #------------------------------------------------------------------------------
  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  location.provider = "geoclue2";

  #------------------------------------------------------------------------------
  # Services Configuration
  #------------------------------------------------------------------------------
  services = {
    # SSH server
    sshd.enable = true;

    # Power management
    upower.enable = true;
    power-profiles-daemon.enable = true;

    # File system utilities
    gvfs.enable = true;
    udisks2.enable = true;

    # Bluetooth
    blueman.enable = true;

    # Input
    libinput.enable = true;

    # Location services
    geoclue2.enable = true;

    # Display manager
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-mocha";
      package = pkgs.kdePackages.sddm;
    };

    # Audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Printing
    printing = {
      enable = true;
      drivers = with pkgs; [ gutenprint gutenprintBin ];
    };

    # Network discovery
    avahi = {
      enable = true;
      openFirewall = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };

    # Database
    postgresql = {
      enable = true;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all 127.0.0.1/32 trust
        host all all ::1/128 trust
      '';
      initialScript = pkgs.writeText "backend-initScript" ''
        CREATE ROLE dmitry WITH LOGIN PASSWORD '123passw0rd5' CREATEDB;
        CREATE DATABASE dmitry;
        GRANT ALL PRIVILEGES ON DATABASE dmitry TO dmitry;
      '';
    };

    # Database admin
    pgadmin = {
      enable = true;
      initialEmail = "imgarison@gmail.com";
      initialPasswordFile = "/etc/pgadmin-password";
    };

    # Enable Nvidia-related services
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" "amdgpu" ];
      displayManager.gdm.wayland = true;
    };
  };

  #------------------------------------------------------------------------------
  # Programs Configuration
  #------------------------------------------------------------------------------
  programs = {
    seahorse.enable = true;

    hyprland = {
      enable = true;
      package = pkgs.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [ "git" ];
      };
      shellAliases = {
        c = "clear";
        nu = "sudo nixos-rebuild switch";
        nvidia-run = "nvidia-offload"; # Alias for nvidia-offload
      };
    };
  };

  #------------------------------------------------------------------------------
  # Virtualization
  #------------------------------------------------------------------------------
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = false;
  };

  #------------------------------------------------------------------------------
  # Fonts Configuration
  #------------------------------------------------------------------------------
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [ nerd-fonts.jetbrains-mono inter ];
  };

  #------------------------------------------------------------------------------
  # Nix Configuration
  #------------------------------------------------------------------------------
  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };
    settings = {
      trusted-users = [ "root" "@wheel" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  #------------------------------------------------------------------------------
  # User Configuration
  #------------------------------------------------------------------------------
  users.users.dmitry = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "networkmanager" "audio" "input" "video" "vboxusers" ];
    shell = pkgs.zsh;
  };
}
