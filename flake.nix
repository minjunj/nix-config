{
  description = "Ubuntu 24.04 Nix 설정";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      lib = nixpkgs.lib;
    in {
      homeConfigurations.ubuntu = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
        ];
      };

      apps.${system}.default = {
        type = "app";
        program = toString (pkgs.writeShellScriptBin "apply-config" ''
          #!${pkgs.bash}/bin/bash
          echo "Nix 설정을 적용합니다..."
          ${home-manager}/bin/home-manager switch --flake ${self}#ubuntu
        ''
        + "/bin/apply-config");
      };
    };
}
