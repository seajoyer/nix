{
  description = "NixOS and Home Manager configuration";

  outputs = { nixpkgs, home-manager, catppuccin, ags, niri-flake, ... }@inputs:
    let
      system = "x86_64-linux";

      overlay = final: prev: import ./home/pkgs { pkgs = prev; };

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ overlay niri-flake.overlays.niri ];
        config.allowUnfree = true;
      };

    in {
      nixosConfigurations = {
        "ideapad" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs system; };
          modules = [ ./system/configuration.nix ];
        };
      };

      homeConfigurations = {
        "dmitry@ideapad" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./profiles/ideapad/dmitry/home.nix
            catppuccin.homeModules.catppuccin
          ];
        };
      };
    };

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ax-shell = {
      url = "github:poogas/Ax-Shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ambxst = {
      url = "github:Axenide/Ambxst";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # dankMaterialShell = {
    #   url = "github:AvengeMedia/DankMaterialShell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.dgop.follows = "dgop";
    # };

    catppuccin.url = "github:catppuccin/nix";

    # hyprland.url = "github:hyprwm/Hyprland/v0.50.1";

    # hyprtasking = {
    #   url = "github:raybbian/hyprtasking";
    #   inputs.hyprland.follows = "hyprland";
    # };

    doomemacs = {
      url = "github:doomemacs/doomemacs";
      flake = false;
    };

    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
