{
  description = "NixOS and Home Manager configuration";

  outputs = { nixpkgs, home-manager, catppuccin, ags, ... }@inputs:
    let
      system = "x86_64-linux";

      overlay = final: prev: import ./home/pkgs { pkgs = prev; };

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ overlay ];
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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia-cli = {
      url = "github:caelestia-dots/cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    pyprland.url = "github:hyprland-community/pyprland";

    hyprland.url = "github:hyprwm/Hyprland/v0.49.0";

    hyprtasking = {
      url = "github:raybbian/hyprtasking";
      inputs.hyprland.follows = "hyprland";
    };

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
