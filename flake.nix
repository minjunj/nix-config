{
  description = "Ubuntu 24.04 Nix 설정";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=b62d2a95c72fb068aecd374a7262b37ed92df82b";
    home-manager-2411 = {
      url = "github:nix-community/home-manager?ref=9d3d080aec2a35e05a15cedd281c2384767c2cfe";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs-unstable, home-manager-2411, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      lib = nixpkgs-unstable.lib;
    in {
      homeConfigurations.ubuntu = home-manager-2411.lib.homeManagerConfiguration {
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
          ${home-manager-2411.packages.${system}.default}/bin/home-manager switch --flake ${self}#ubuntu
        ''
        + "/bin/apply-config");
      };
    };
}
