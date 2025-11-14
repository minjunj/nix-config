# nuc_n100 host-specific configuration
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../nixos/common.nix
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  # Set hostname for this host
  networking.hostName = "nuc_n100";

  # Integrate home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    users.minjunj = import ../../home-manager/home.nix;
  };
}
