# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  time.timeZone = "Europe/Moscow";

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 30;
    };
    efi.canTouchEfiVariables = true;
  };

  hardware = {
    brillo.enable = true;
    opengl.enable = true;
    bluetooth = {
      enable = true;
      input = { General = { IdleTimeout = 10; }; };
    };
  };

  systemd.services.bluetooth = {
    enable = true;
    unitConfig = {
      # This will make the service installed but disabled by default
      DefaultState = "disabled";
    };
  };

  networking = {
    hostName = "ideapad";
    networkmanager.enable = true;
    iproute2.enable = true;
    enableIPv6 = true;
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
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [

    kitty

    vim
    vifm
    neovim

    git
    wget
    curl
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

    packages = with pkgs;
      [ (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];
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
