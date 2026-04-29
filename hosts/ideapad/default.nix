{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware.nix
    inputs.niri-flake.nixosModules.niri
  ];

  nixpkgs.overlays = [ inputs.niri-flake.overlays.niri ];

  # ── System ────────────────────────────────────────────────────────────────
  time.timeZone = "Europe/Moscow";
  system.stateVersion = "24.05"; # never change

  # ── Boot ──────────────────────────────────────────────────────────────────
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
    initrd.kernelModules = [ "amdgpu" ];
    kernelModules = [
      "ideapad_laptop"
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
    kernelParams = [ "kvm.enable_virt_at_load=0" ];
    blacklistedKernelModules = [ "nouveau" ];
  };

  # ── Hardware ──────────────────────────────────────────────────────────────
  hardware = {
    brillo.enable = true;

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa
        rocmPackages.clr.icd
        nvidia-vaapi-driver
      ];
    };

    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };

    nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = false;
        finegrained = true;
      };
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        amdgpuBusId = "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  # ── Environment ───────────────────────────────────────────────────────────
  environment = {
    sessionVariables = {
      QT_QPA_PLATFORM = "wayland;xcb";
      NIXOS_OZONE_WL = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
      CUDA_HOME = "${pkgs.cudaPackages.cudatoolkit}";
      LD_LIBRARY_PATH = "${pkgs.cudaPackages.cudatoolkit}/lib:${pkgs.cudaPackages.cudnn}/lib";
    };

    pathsToLink = [
      "/run/current-system/sw/share/xdg-desktop-portal"
      "/share/xdg-desktop-portal"
      "/share/applications"
    ];

    systemPackages = with pkgs; [
      # essentials
      vim
      git
      wget
      curl

      # GPU / hardware
      clinfo
      lshw
      mesa-demos
      vulkan-tools
      linuxPackages.nvidia_x11
      cudaPackages.cudatoolkit

      # session bootstrap (needed before HM activates)
      egl-wayland
      libsecret
      libxkbcommon
      xwayland-satellite
      libGL
      libx11
      libxcursor
      libxrandr
      libxi
      nss
      alsa-lib
      at-spi2-core
      glib

      # JS runtime — some system services depend on it
      nodejs
      esbuild

      # display manager theme
      where-is-my-sddm-theme
    ];
  };

  # ── Networking ────────────────────────────────────────────────────────────
  networking = {
    hostName = "ideapad";
    networkmanager.enable = true;
    iproute2.enable = true;
    enableIPv6 = true;
    firewall.allowedTCPPorts = [
      5432
      5173
    ];
    extraHosts = "127.0.0.1 tma.internal";
  };

  # ── Security ──────────────────────────────────────────────────────────────
  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };
  location.provider = "geoclue2";

  # ── Services ──────────────────────────────────────────────────────────────
  services = {
    sshd.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    blueman.enable = true;
    libinput.enable = true;
    geoclue2.enable = true;
    gnome.gnome-keyring.enable = true;
    desktopManager.gnome.enable = false;

    displayManager = {
      defaultSession = "niri";
      gdm.enable = false;
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

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    orca.enable = false;

    printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint
        gutenprintBin
      ];
    };

    avahi = {
      enable = true;
      openFirewall = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };

    postgresql = {
      enable = false;
    };
    pgadmin = {
      enable = false;
    };

    xserver = {
      enable = true;
      videoDrivers = [
        "nvidia"
        "amdgpu"
      ];
    };
  };

  # ── Programs ──────────────────────────────────────────────────────────────
  programs = {
    nix-ld.enable = false;

    niri = {
      enable = true;
      package = pkgs.niri-stable;
    };

    hyprland = {
      enable = false;
      # portalPackage = pkgs.xdg-desktop-portal-hyprland;
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
      };
    };

    throne = {
      enable = true;
      tunMode.enable = true;
    };
  };

  # ── Virtualisation ────────────────────────────────────────────────────────
  virtualisation = {
    docker.enable = true;
    virtualbox.host = {
      enable = true;
      enableExtensionPack = false;
    };
  };

  # ── Fonts ─────────────────────────────────────────────────────────────────
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      inter
    ];
  };

  # ── Nix ───────────────────────────────────────────────────────────────────
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

  # ── Users ─────────────────────────────────────────────────────────────────
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
