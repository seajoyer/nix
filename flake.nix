{
  description = "NixOS and Home Manager configuration";

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
    in
      {
        nixosConfigurations = {
          "ideapad" = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs;
              inherit system;
            };
            modules = [ ./profiles/ideapad/configuration.nix ];
          };
        };

        homeConfigurations = {
          "dmitry@ideapad" = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs { inherit system; };
            extraSpecialArgs =    { inherit inputs; };
            modules = [ ./profiles/ideapad/dmitry/home.hix ];
          };
        };
      };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    doomemacs = {
      url = "github:doomemacs/doomemacs";
      flake = false;
    };
  };
}
