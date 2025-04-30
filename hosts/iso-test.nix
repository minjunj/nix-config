{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  networking.hostName = "nixos-test";
  time.timeZone = "Asia/Seoul";

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    password = "1234";
    shell = pkgs.zsh;  # 기본 쉘을 zsh로 설정
  };

  services.sshd.enable = true;

  system.stateVersion = "24.11";
}
