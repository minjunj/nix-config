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

  # nixos 유저를 시스템 유저로 변경 (로그인 불가)
  users.users.nixos = {
    isNormalUser = lib.mkForce false;
    isSystemUser = lib.mkForce true;
    group = lib.mkForce "nixos";
  };
  users.groups.nixos = {};

  # getty 자동 로그인 비활성화
  services.getty.autologinUser = lib.mkForce null;

  # alice로 자동 로그인
  services.displayManager.autoLogin = {
    enable = lib.mkForce true;
    user = "alice";
  };

  # sudo 비밀번호 없이 사용
  security.sudo.wheelNeedsPassword = false;
}
