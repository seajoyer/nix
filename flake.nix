{
  description = "NixOS and Home Manager configuration";

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      overlay = final: prev: import ./home/pkgs { pkgs = prev; };

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ overlay ];
        config = { allowUnfree = true; };
      };

    in {

      nixosConfigurations = {
        "ideapad" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit system;
          };
          modules = [ ./system/configuration.nix ];
        };
      };

      homeConfigurations = {
        "dmitry@ideapad" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./profiles/ideapad/dmitry/home.nix ];
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

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
