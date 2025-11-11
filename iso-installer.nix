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

  # Sway 활성화
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # 설치 ISO에 포함할 추가 패키지
  environment.systemPackages = with pkgs; [
    # 기본 유틸리티
    vim
    git
    wget
    curl

    # 파티션 관리
    parted
    gparted

    # Sway 필수 패키지
    sway
    swaylock
    swayidle
    foot           # 터미널
    alacritty      # 대체 터미널
    wofi           # 애플리케이션 런처
    waybar         # 상태바

    # Wayland 유틸리티
    wl-clipboard   # 클립보드
    grim           # 스크린샷
    slurp          # 영역 선택
    mako           # 알림

    # 브라우저
    firefox
  ];

  # 자동 로그인 (설치 편의성)
  services.displayManager.autoLogin = {
    enable = true;
    user = "nixos";
  };

  # sudo 비밀번호 없이 사용
  security.sudo.wheelNeedsPassword = false;

  # nixos 사용자 추가 설정
  users.users.nixos = {
    extraGroups = [ "video" "input" "seat" ];
  };

  # 자동으로 Sway 실행
  environment.loginShellInit = ''
    if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
      exec sway
    fi
  '';

  # XDG 런타임 디렉토리
  security.pam.services.login.enableGnomeKeyring = true;
}
