{
  description = "Custom NixOS ISO flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        isoConfig = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/iso-test.nix
            ./hosts/zsh/base.nix
          ];
        };
      in {
        packages.iso = isoConfig.config.system.build.isoImage;
      }
    );
}
