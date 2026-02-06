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
    ../../nixos/nas.nix
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    ../../users/minjunj.nix
    ../../secret/1password.nix
    ../../hardware/nvidia/nvidia.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set hostname for this host
  networking.hostName = "desktop";
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
