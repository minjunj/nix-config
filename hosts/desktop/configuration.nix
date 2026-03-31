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
    ../../modules/nixos/nas.nix
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.niri-flake.nixosModules.niri
    ../../modules/users/minjunj.nix
    ./other.nix
    ../../secrets/1password.nix
    ../../modules/nixos/hardware/nvidia.nix
    ../../modules/desktop/window_manager/tiling/noctalia.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set hostname for this host
  networking.hostName = "desktop";
  networking.networkmanager.enable = true;

  # Required for xdg-portal with home-manager
  environment.pathsToLink = [ "/share/applications" "/share/xdg-desktop-portal" ];

  # Enable niri compositor
  programs.niri = {
    enable = true;
    package = inputs.niri-flake.packages.${pkgs.system}.niri-unstable;
  };
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.enable = true;

  # Enable xwayland-satellite for X11 app support
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];


  # home-manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
  };
}
