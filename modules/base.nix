# base.nix: 모든 시스템에 공통으로 적용되는 기본 설정
# 여기에는 플랫폼에 관계없이 항상 필요한 설정들이 들어감

{ config, pkgs, lib, hostname, isAsahi, ... }:

{
  # 다른 모듈 import
  imports = [
    ./gnome-macos-theme.nix  # GNOME macOS 스타일 테마
  ];

  # 시스템 전체 설정
  # ==================

  # 네트워킹 설정
  networking = {
    hostName = hostname;  # 호스트 이름 설정 (ultrathink 또는 asahi)
    networkmanager.enable = true;  # GUI로 네트워크 관리 가능
  };

  # 시간대 설정 (한국 시간)
  time.timeZone = "Asia/Seoul";

  # 로케일 설정 (언어 및 지역)
  i18n = {
    defaultLocale = "en_US.UTF-8";  # 기본은 영어
    extraLocaleSettings = {
      # 한글 입력을 위한 설정
      LC_ADDRESS = "ko_KR.UTF-8";
      LC_IDENTIFICATION = "ko_KR.UTF-8";
      LC_MEASUREMENT = "ko_KR.UTF-8";
      LC_MONETARY = "ko_KR.UTF-8";
      LC_NAME = "ko_KR.UTF-8";
      LC_NUMERIC = "ko_KR.UTF-8";
      LC_PAPER = "ko_KR.UTF-8";
      LC_TELEPHONE = "ko_KR.UTF-8";
      LC_TIME = "ko_KR.UTF-8";
    };
  };

  # 데스크톱 환경: GNOME
  # ====================
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;  # GDM 로그인 매니저
    desktopManager.gnome.enable = true;  # GNOME 데스크톱

    # 키보드 설정
    xkb = {
      layout = "us";  # 기본 키보드 레이아웃
      variant = "";
    };
  };

  # 한글 입력기 설정 (fcitx5 + 한글 입력)
  # NixOS 25.11 새로운 문법
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-hangul  # 한글 입력
    ];
  };

  # 사운드 설정 (PipeWire - 최신 오디오 시스템)
  sound.enable = true;
  hardware.pulseaudio.enable = false;  # PulseAudio 비활성화
  security.rtkit.enable = true;  # 실시간 오디오 처리
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;  # JACK 호환성
  };

  # Docker 설정
  # ===========
  virtualisation.docker = {
    enable = true;
    # Docker 데몬 옵션 설정
    extraOptions = ''
      --default-runtime=nvidia
    '';
  };

  # 사용자 계정 설정
  # ===============
  users.users.user = {
    isNormalUser = true;  # 일반 사용자 계정
    description = "User";
    # 사용자가 속할 그룹들
    extraGroups = [
      "networkmanager"  # 네트워크 설정 권한
      "wheel"           # sudo 권한
      "docker"          # Docker 사용 권한
    ];
    # 기본 쉘을 zsh로 설정
    shell = pkgs.zsh;
  };

  # zsh를 시스템 쉘로 등록
  programs.zsh.enable = true;

  # 시스템 전체에 설치할 필수 패키지들
  # ==================================
  environment.systemPackages = with pkgs; [
    # 기본 유틸리티
    vim
    wget
    curl
    git
    htop
    tree
    unzip
    zip

    # 네트워크 도구
    networkmanagerapplet

    # 개발 도구
    gcc
    gnumake

    # 파일 관리
    rsync

    # GUI 애플리케이션
    # ===============
    google-chrome   # Chrome 웹 브라우저
    # VSCode는 home.nix에서 설치됨 (사용자별 확장 관리를 위해)
  ];

  # 격리된 작업 폴더 설정
  # ====================
  # systemd-tmpfiles: 부팅시 자동으로 디렉토리 생성
  systemd.tmpfiles.rules = [
    # /home/user/workspace 디렉토리 생성
    # d: 디렉토리, 755: 권한, user:user: 소유자
    "d /home/user/workspace 0755 user user -"
    "d /home/user/workspace/scratch 0755 user user -"
  ];

  # Nix 설정
  # ========
  nix = {
    settings = {
      # Flakes와 nix command 활성화 (실험적 기능)
      experimental-features = [ "nix-command" "flakes" ];

      # 자동 최적화: 중복 파일 하드링크로 연결해서 디스크 절약
      auto-optimise-store = true;
    };

    # 자동 가비지 컬렉션 (오래된 패키지 삭제)
    gc = {
      automatic = true;
      dates = "weekly";  # 매주 실행
      options = "--delete-older-than 30d";  # 30일 이상 된 것만 삭제
    };
  };

  # 시스템 업그레이드 자동화
  system.autoUpgrade = {
    enable = false;  # 수동으로 업그레이드하려면 false로 유지
    # enable = true;  # 자동 업그레이드 원하면 주석 해제
  };

  # NixOS 버전 (자동 생성됨, 건드리지 말 것)
  system.stateVersion = "24.05";
}
