# asahi/configuration.nix
# ARM64 시스템(Apple Silicon Mac)에 특화된 설정
# Asahi Linux 전용

{ config, pkgs, lib, ... }:

{
  imports = [
    # Asahi Linux 하드웨어 설정
    ./hardware-configuration.nix
  ];

  # 부트로더 설정
  # =============
  # Asahi Linux는 U-Boot를 사용
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = false;  # Apple Silicon에서는 false
  };

  # ARM64 전용 커널 설정
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Apple Silicon 전용 펌웨어 및 드라이버
  # ===================================
  hardware.asahi = {
    # Asahi Linux 커널 및 드라이버 사용
    useExperimentalGPUDriver = true;  # GPU 가속 (실험적)
    experimentalGPUInstallMode = "replace";  # GPU 드라이버 설치 방식
    setupAsahiSound = true;  # Apple 오디오 하드웨어 지원
  };

  # OpenGL 설정 (Apple GPU 가속)
  hardware.opengl = {
    enable = true;
    # Mesa 드라이버 사용 (Asahi GPU 드라이버)
  };

  # 전원 관리 (노트북 배터리 최적화)
  # ==============================
  services.tlp = {
    enable = true;  # 배터리 수명 최적화
    settings = {
      # CPU 성능 모드
      CPU_SCALING_GOVERNOR_ON_AC = "performance";    # 전원 연결 시
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";     # 배터리 사용 시

      # USB 자동 절전
      USB_AUTOSUSPEND = 1;
    };
  };

  # 터치패드 및 입력 장치 설정
  # =========================
  services.xserver.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;  # macOS 스타일 스크롤
      tapping = true;           # 탭으로 클릭
      disableWhileTyping = true;  # 타이핑 중 터치패드 비활성화
    };
  };

  # 시스템별 추가 패키지
  # ===================
  environment.systemPackages = with pkgs; [
    # ARM64 전용 도구들
    # (필요시 추가)
  ];

  # NixOS 상태 버전 (설치한 NixOS 버전, 변경 금지)
  system.stateVersion = "24.05";
}
