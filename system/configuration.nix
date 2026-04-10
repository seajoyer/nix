{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    inputs.niri-flake.nixosModules.niri
  ];

  nixpkgs.overlays = [ inputs.niri-flake.overlays.niri ];

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
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
    # Load both AMD and Nvidia modules
    initrd.kernelModules = [ "amdgpu" ];
    kernelModules = [
      "ideapad_laptop"
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
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
        rocmPackages.clr.icd
        nvidia-vaapi-driver # For Nvidia video acceleration
      ];
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
        enable = false; # Enable power management
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

      CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
      CUDA_HOME = "${pkgs.cudaPackages.cudatoolkit}";
      LD_LIBRARY_PATH = "${pkgs.cudaPackages.cudatoolkit}/lib:${pkgs.cudaPackages.cudnn}/lib";
    };

    pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];

    # System packages
    systemPackages = with pkgs; [
      # GPU utilities
      # nvidia-offload # Include nvidia-offload script
      clinfo
      lshw
      mesa-demos
      vulkan-tools

      # CUDA and ML-related packages
      linuxPackages.nvidia_x11
      cudaPackages.cudatoolkit

      # Terminal and editors
      kitty
      vim
      vifm
      neovim
      emacs-pgtk

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
      xwayland-satellite
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
      nautilus
      qt5.qtwayland
      qt6.qtwayland
      qt6Packages.qttools
      qt6Packages.qt5compat
      qt6Packages.qtwayland

      # Web development
      esbuild
      electron
      nodejs
      bun

      # Themes
      where-is-my-sddm-theme
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
    firewall = {
      allowedTCPPorts = [
        5432
        5173
      ];
    };
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

    # desktopManager.cosmic.enable = true;
    # desktopManager.cosmic.xwayland.enable = true;
    # desktopManager.gnome.enable = true;

    gnome.gnome-keyring.enable = true;

    # Display manager
    displayManager = {
      defaultSession = "niri";

      gdm = {
        enable = false;
        wayland = true;
      };

      sddm = {
        enable = true;
        wayland.enable = true;
        theme = "where_is_my_sddm_theme";
        package = pkgs.kdePackages.sddm;

        extraPackages = with pkgs; [
          qt6.qt5compat
          qt6.qtsvg
        ];
      };
    };

    # Audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    # screen reader
    orca.enable = false;

    # Printing
    printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint
        gutenprintBin
      ];
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
      enable = false;
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
      enable = false;
      initialEmail = "imgarison@gmail.com";
      initialPasswordFile = "/etc/pgadmin-password";
    };

    # Enable Nvidia-related services
    xserver = {
      enable = true;
      videoDrivers = [
        "nvidia"
        "amdgpu"
      ];
    };
  };

  #------------------------------------------------------------------------------
  # Programs Configuration
  #------------------------------------------------------------------------------
  programs = {
    nix-ld.enable = false;

    # uwsm acts as a session manager wrapper: it imports the compositor's
    # environment into the systemd user manager and activates
    # graphical-session.target, which is what xdg-desktop-portal waits for.
    niri = {
      enable = true;
      package = pkgs.niri;
    };

    hyprland = {
      enable = false;
      package = pkgs.hyprland;
      xwayland.enable = true;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };

    seahorse.enable = true;

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
        nvidia-run = "nvidia-offload";
      };
    };

    throne = {
      enable = true;
      tunMode.enable = true;
    };
  };

  #------------------------------------------------------------------------------
  # Virtualization
  #------------------------------------------------------------------------------
  virtualisation = {
    docker.enable = true;

    virtualbox.host = {
      enable = true;
      enableExtensionPack = false;
    };
  };

  #------------------------------------------------------------------------------
  # Fonts Configuration
  #------------------------------------------------------------------------------
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      inter
    ];
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
      trusted-users = [
        "root"
        "@wheel"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  #------------------------------------------------------------------------------
  # User Configuration
  #------------------------------------------------------------------------------
  users.users.dmitry = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "input"
      "video"
      "vboxusers"
      "docker"
    ];
    shell = pkgs.zsh;
  };
}
