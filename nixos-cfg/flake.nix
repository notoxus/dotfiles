{
  description = "Niri - NixOS Config";

  inputs = {
    # Properly amdgpu firmware for my 680M radeon laptop
    nixpkgs.url =
      "github:NixOS/nixpkgs/d2f0551226ee44652aebf6217752cc78f7a47e84";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    easyeffects-presets = {
      url = "github:JackHack96/EasyEffects-Presets";
      flake = false;
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    nixosConfigurations.juosterben = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        inherit inputs;
      };

      modules = [
        ./configuration.nix

        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
             inherit inputs;
          };
          home-manager.users.juo = import ./home.nix;
          home-manager.backupFileExtension = "backup";
        }
      ];
    };
  };
}
