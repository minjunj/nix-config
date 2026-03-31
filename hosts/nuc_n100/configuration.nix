# nuc_n100 host-specific configuration
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/nixos/common.nix
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    ../../modules/users/minjunj.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set hostname for this host
  networking.hostName = "nuc_n100";
  networking.networkmanager.enable = true;

  # Enable KDE Plasma on Wayland
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # home-manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    sharedModules = [
      inputs.plasma-manager.homeModules.plasma-manager
    ];
  };
}
