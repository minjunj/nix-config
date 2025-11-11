{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    # NixOS 기본 설치 ISO (최소 버전)
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"

    # 당신의 커스텀 설정 포함
    ./configuration.nix
  ];

  # ISO 이미지 설정
  isoImage = {
    # ISO 파일명
    isoName = "nixos-installer-x86_64.iso";

    # UEFI/BIOS 부팅 지원
    makeEfiBootable = true;
    makeUsbBootable = true;
  };

  # 네트워크 설정
  networking = {
    hostName = "nixos-installer";
    networkmanager.enable = true;
    wireless.enable = false;
  };

  # 설치 ISO에 포함할 추가 패키지
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
    parted
    gparted
    firefox
  ];

  # 자동 로그인 (설치 편의성)
  services.displayManager.autoLogin = {
    enable = true;
    user = "nixos";
  };

  # sudo 비밀번호 없이 사용
  security.sudo.wheelNeedsPassword = false;
}
