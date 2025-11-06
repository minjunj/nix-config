# installer.nix
# NixOS 설치용 ISO 이미지 생성 설정
# 이 설정으로 부팅 가능한 USB/ISO를 만들 수 있음

{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    # NixOS 기본 설치 ISO 프로필
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
    # GNOME 데스크톱이 포함된 설치 ISO
    # 최소 버전 원하면: installation-cd-minimal.nix
  ];

  # ISO 메타데이터
  # ==============
  # NixOS 25.11에서 isoImage 옵션이 변경됨
  image.fileName = "nixos-custom-installer.iso";

  isoImage = {
    # 볼륨 라벨 (USB 이름)
    volumeID = "NIXOS_INSTALLER";

    # 부트로더 설정
    makeEfiBootable = true;   # UEFI 부팅 가능
    makeUsbBootable = true;   # USB 부팅 가능

    # ISO 압축 (용량 줄임)
    squashfsCompression = "zstd";
  };

  # 네트워킹 설정
  # =============
  networking = {
    hostName = "nixos-installer";
    networkmanager.enable = true;  # GUI 네트워크 관리
    wireless.enable = false;       # wpa_supplicant 비활성화 (NetworkManager 사용)
  };

  # 설치 ISO에 포함할 추가 패키지들
  # ================================
  environment.systemPackages = with pkgs; [
    # 기본 유틸리티
    vim
    nano
    git
    wget
    curl
    htop
    tree

    # 파티션 관리
    gparted         # GUI 파티션 편집기
    parted          # CLI 파티션 도구

    # 파일시스템 도구
    e2fsprogs       # ext4
    dosfstools      # FAT32
    ntfs3g          # NTFS
    exfatprogs      # exFAT

    # 네트워크 도구
    networkmanagerapplet
    firefox         # 웹 브라우저 (문서 참조용)

    # 압축 도구
    unzip
    zip
    p7zip

    # 하드웨어 정보
    pciutils        # lspci
    usbutils        # lsusb
    lshw            # 하드웨어 정보

    # 디스크 관리
    smartmontools   # 디스크 건강 확인

    # 터미널 (NixOS 25.11에서 gnome.gnome-terminal이 최상위로 이동)
    gnome-terminal
  ];

  # 자동 로그인 (설치 편의성)
  # ========================
  # NixOS 25.11에서 autoLogin 경로 변경
  services.displayManager.autoLogin = {
    enable = true;
    user = "nixos";  # 설치 ISO 기본 사용자
  };

  # 설치 ISO의 기본 사용자
  # ======================
  # ISO 프로필에서 이미 nixos 사용자가 정의되어 있으므로
  # 비밀번호 설정만 덮어쓰기
  users.users.nixos.hashedPassword = lib.mkForce "";

  # sudo 비밀번호 없이 사용 (설치 편의성)
  security.sudo.wheelNeedsPassword = false;

  # 설치 가이드 포함
  # ===============
  # ISO에 이 저장소의 설정을 미리 포함
  environment.etc."nixos-config" = {
    source = ../.;  # 상위 디렉토리 전체 (nix-config)
    target = "nixos-config";
  };

  # 설치 스크립트를 데스크톱에 배치
  # ==============================
  system.activationScripts.installer-setup = ''
    # 설치 가이드 바로가기 생성
    mkdir -p /home/nixos/Desktop
    cat > /home/nixos/Desktop/installation-guide.desktop << 'EOF'
    [Desktop Entry]
    Type=Application
    Name=Installation Guide
    Comment=NixOS Installation Guide
    Exec=firefox file:///etc/nixos-config/INSTALL.md
    Icon=text-html
    Terminal=false
    Categories=Utility;
    EOF
    chmod +x /home/nixos/Desktop/installation-guide.desktop
    chown nixos:users /home/nixos/Desktop/installation-guide.desktop
  '';

  # 한글 지원
  # =========
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "ko_KR.UTF-8/UTF-8"
    ];

    # 한글 입력기 (NixOS 25.11 새로운 문법)
    inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
        fcitx5-hangul
      ];
    };
  };

  # 폰트 (한글 폰트 포함)
  # ====================
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans  # 한중일 통합 폰트 (Sans)
    noto-fonts-cjk-serif # 한중일 통합 폰트 (Serif)
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
  ];

  # 시간대
  time.timeZone = "Asia/Seoul";

  # NixOS 버전
  system.stateVersion = "24.05";
}

# ISO 빌드 방법
# =============
#
# 1. 이 디렉토리에서 빌드:
#    nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso/installer.nix
#
# 2. 또는 flake를 이용한 빌드:
#    nix build .#nixosConfigurations.installer.config.system.build.isoImage
#
# 3. 생성된 ISO 위치:
#    result/iso/nixos-custom-installer.iso
#
# 4. USB에 굽기:
#    sudo dd if=result/iso/nixos-custom-installer.iso of=/dev/sdX bs=4M status=progress
