{
  description = "NixOS + Home Manager — ideapad";

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      catppuccin,
      niri-flake,
      sops-nix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (import ./pkgs)
          niri-flake.overlays.niri
        ];
      };
    in
    {
      nixosConfigurations.ideapad = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/ideapad
          sops-nix.nixosModules.sops
        ];
      };

      homeConfigurations."dmitry@ideapad" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./home/profiles/dmitry.nix
          catppuccin.homeModules.catppuccin
          sops-nix.homeManagerModules.sops
        ];
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-scratchpad = {
      url = "github:gvolpe/niri-scratchpad";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    doomemacs = {
      url = "github:doomemacs/doomemacs";
      flake = false;
    };
  };
}
