# ultrathink/configuration.nix
# AMD64 시스템(Intel/AMD CPU)에 특화된 설정
# NVIDIA GPU 지원 포함

{ config, pkgs, lib, ... }:

{
  imports = [
    # NixOS 설치 시 자동 생성되는 하드웨어 설정 파일
    # 파티션, 파일시스템, 부트로더 등의 정보가 들어있음
    ./hardware-configuration.nix

    # NVIDIA GPU 설정 (GPU가 있는 경우에만 이 줄 활성화)
    # GPU가 없으면 이 줄을 주석 처리하세요
    ../../modules/nvidia.nix
  ];

  # 부트로더 설정
  # =============
  boot = {
    loader = {
      # systemd-boot: UEFI 시스템용 부트로더 (GRUB보다 간단)
      systemd-boot.enable = true;
      # EFI 변수 수정 허용 (부트 순서 변경 등)
      efi.canTouchEfiVariables = true;
    };

    # 커널 모듈 설정
    kernelModules = [ "kvm-intel" ];  # Intel CPU 가상화 지원
    # AMD CPU 사용 시 "kvm-amd"로 변경

    # 최신 커널 사용 (하드웨어 지원 향상)
    kernelPackages = pkgs.linuxPackages_latest;
  };

  # NVIDIA GPU 설정은 ../../modules/nvidia.nix에서 import됨
  # GPU가 없다면 imports에서 nvidia.nix를 주석 처리하세요

  # 시스템별 추가 패키지
  # ===================
  environment.systemPackages = with pkgs; [
    # 추가 개발 도구
    pciutils  # lspci 명령어 (하드웨어 확인)
  ];

  # NixOS 상태 버전 (설치한 NixOS 버전, 변경 금지)
  system.stateVersion = "24.05";
}
