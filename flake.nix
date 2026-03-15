{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nixos-hardware,
    ...
  }:
  let
    system = "x86_64-linux";

    commonModules = [
      ./configuration.nix
      ./autoupdate.nix
      ./1password.nix
      ./steam.nix
      ./jetbrains-toolbox.nix


      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.sburba = ./home.nix;
        home-manager.extraSpecialArgs = {
          inherit nixpkgs-unstable;
        };
      }
    ];

    mkHost = extraModules:
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules = commonModules ++ extraModules;
      };
  in
  {
    nixosConfigurations = {
      sburba-laptop = mkHost [
        ./hardware/laptop-hardware.nix
        nixos-hardware.nixosModules.framework-amd-ai-300-series
        ./laptop-wifi.nix
      ];

      sburba-desktop = mkHost [
        ./hardware/desktop-hardware.nix
      ];
    };
  };
}
