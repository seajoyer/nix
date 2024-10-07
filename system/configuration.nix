# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  time.timeZone = "Europe/Moscow";

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 30;
      };
      efi.canTouchEfiVariables = true;
    };
    initrd.kernelModules = [ "amdgpu" ];
    kernelModules = [ "ideapad_laptop" ];
  };

  hardware = {
    brillo.enable = true;

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ rocmPackages.clr.icd ];
    };

    bluetooth = {
      enable = true;
      # input = { General = { IdleTimeout = 60; }; };
    };

    # nvidia = {
    #   modesetting.enable = true;
    #   powerManagement = {
    #     enable = false;
    #     finegrained = false;
    #   };
    #   open = false;
    #   nvidiaSettings = true;
    #   package = config.boot.kernelPackages.nvidiaPackages.production;
    #   prime = {
    #     offload = {
    #       enable = true;
    #       enableOffloadCmd = true;
    #     };
    #     amdgpuBusId = "PCI:5:0:0";
    #     nvidiaBusId = "PCI:1:0:0";
    #   };
    # };
  };

  systemd = {
    services.bluetooth = {
      enable = true;
      # unitConfig = { DefaultState = "disabled"; };
    };
    # tmpfiles.rules =
    #   [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];
  };

  networking = {
    hostName = "ideapad";
    networkmanager.enable = true;
    iproute2.enable = true;
    enableIPv6 = true;
    firewall = {
      allowedTCPPorts = [ 5432 ];
    };
  };

  # rtkit is optional but recommended
  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  location.provider = "geoclue2";

  services = {

    sshd.enable = true;

    upower.enable = true;
    power-profiles-daemon.enable = true;

    gvfs.enable = true;
    udisks2.enable = true;

    blueman.enable = true;

    libinput.enable = true;

    geoclue2.enable = true;
    localtimed.enable = true;

    gnome.gnome-keyring.enable = true;

    # xserver.videoDrivers = [ "nvidia" ];

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-mocha";
      package = pkgs.kdePackages.sddm;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };

    printing = {
      enable = true;
      drivers = with pkgs; [ gutenprint gutenprintBin ];
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
      enable = true;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all 127.0.0.1/32 trust
        host all all ::1/128 trust
      '';
      initialScript = pkgs.writeText "backend-initScript" ''
        CREATE ROLE dmitry WITH LOGIN PASSWORD '123passw0rd5' CREATEDB;
        CREATE DATABASE nixdefault;
        GRANT ALL PRIVILEGES ON DATABASE nixdefault TO dmitry;
      '';
    };
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    # nvidia-offload
    clinfo
    lshw

    kitty

    vim
    vifm
    neovim

    git
    wget
    curl
    (catppuccin-sddm.override {
      flavor = "mocha";
      font = "Inter";
      fontSize = "15";
      # background = "${./wallpaper.png}";
      loginBackground = false;
    })
  ];

  programs = {

    seahorse.enable = true;

    hyprland.enable = true;

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
      };
    };
  };

  fonts = {
    fontDir.enable = true;

    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      inter
    ];
  };

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

  # Define a user account.
  users.users.dmitry = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "input" "video" ];
    shell = pkgs.zsh;
  };

  system.stateVersion = "24.05"; # Never change

}
