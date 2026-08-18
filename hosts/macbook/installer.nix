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
    glibc.bin
    htop
    openssh
    rsync
    vim
    wget
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = true;
      PermitRootLogin = "yes";
    };
  };

  users.users.root.initialPassword = "nixos";
  users.users.nixos = {
    initialPassword = "nixos";
    extraGroups = [ "wheel" ];
  };
  security.sudo.wheelNeedsPassword = false;

  # The upstream installer module uses ISO file systems; keep host disk layout
  # out of this image even if this module later grows MacBook-specific imports.
  fileSystems = lib.mkDefault {};
}
