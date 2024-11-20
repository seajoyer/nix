{
  description = "NixOS and Home Manager configuration";

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, catppuccin, ... }@inputs:
    let
      system = "x86_64-linux";

      overlay = final: prev: import ./home/pkgs { pkgs = prev; };

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ overlay ];
        config = { allowUnfree = true; };
      };

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config = { allowUnfree = true; };
      };

    in {

      nixosConfigurations = {
        "ideapad" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit system;
            inherit pkgs-unstable;
          };
          modules = [ ./system/configuration.nix ];
        };
      };

      homeConfigurations = {
        "dmitry@ideapad" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
            inherit pkgs-unstable;
          };
          modules = [
            ./profiles/ideapad/dmitry/home.nix
            catppuccin.homeManagerModules.catppuccin
          ];
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    pyprland.url = "github:hyprland-community/pyprland";

    doomemacs = {
      url = "github:doomemacs/doomemacs";
      flake = false;
    };

    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
