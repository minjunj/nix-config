{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./asahi.nix
  ];

  image.baseName = lib.mkForce "nixos-asahi-macbook-installer";

  environment.systemPackages = with pkgs; [
    curl
    git
    htop
    rsync
    vim
    wget
  ];

  services.openssh.enable = true;

  # The upstream installer module uses ISO file systems; keep host disk layout
  # out of this image even if this module later grows MacBook-specific imports.
  fileSystems = lib.mkDefault {};
}
