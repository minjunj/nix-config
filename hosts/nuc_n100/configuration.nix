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
    ../../modules/users/nuc_n100.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set hostname for this host
  networking.hostName = "nuc_n100";
  networking.networkmanager.enable = true;

  my.nas.credentialsFile = "/home/nuc_n100/nix-config/secrets/smb-secret";

  # Headless host: SSH/TTY only, no display manager or desktop environment.
  systemd.defaultUnit = "multi-user.target";

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      default-address-pools = [
        {
          base = "172.30.0.0/16";
          size = 24;
        }
      ];
    };
  };

  # home-manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
  };
}
