{ config, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
  ];

  networking.hostName = "nixos-test";
  time.timeZone = "Asia/Seoul";

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    password = "1234"; # 실사용용 X. 테스트용
  };

  services.sshd.enable = true;

  system.stateVersion = "24.11"; # 현재 NixOS 버전에 맞게
}
