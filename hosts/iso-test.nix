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

  # zsh를 설치
  environment.systemPackages = with pkgs; [
    zsh
  ];

  programs.zsh = {
    enable = true;

    # oh-my-zsh 설정
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" ];
      theme = "";
    };

  };

  system.stateVersion = "24.11";
}
