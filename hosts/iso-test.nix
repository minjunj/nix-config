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

  # zsh 설정 활성화
  programs.zsh.enable = true;

  # Oh My Zsh 설정 (기본 설정 추가)
  programs.zsh.zshrc = ''
    export ZSH=$HOME/.oh-my-zsh
    export ZSH_THEME="agnoster"  # 원하는 테마로 설정 가능
  '';

  system.stateVersion = "24.11";
}
