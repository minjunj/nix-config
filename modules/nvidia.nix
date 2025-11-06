# nvidia.nix
# NVIDIA GPU 전용 설정 모듈
# GPU가 있는 호스트에서만 import하여 사용

{ config, pkgs, lib, ... }:

{
  # NVIDIA GPU 감지 및 설정
  # ======================

  # NVIDIA 하드웨어 설정
  hardware.nvidia = {
    # Modesetting 필수 (최신 디스플레이 관리)
    # Wayland 지원에 필요
    modesetting.enable = true;

    # 전원 관리 활성화
    # 노트북에서 배터리 수명 향상
    # 데스크톱에서도 유휴 시 전력 절약
    powerManagement.enable = true;

    # Fine-grained 전원 관리 (실험적)
    # GPU를 더 세밀하게 절전 모드로 전환
    # 문제가 생기면 false로 변경
    powerManagement.finegrained = false;

    # 오픈소스 GPU 커널 모듈 사용 여부
    # false = NVIDIA 공식 드라이버 (안정적, 성능 우수, 권장)
    # true = 오픈소스 Nouveau 기반 드라이버 (실험적)
    open = false;

    # nvidia-settings GUI 도구 설치
    # GPU 설정, 모니터 구성, 오버클럭 등 가능
    nvidiaSettings = true;

    # 드라이버 버전 선택
    # stable: 안정 버전 (권장)
    # beta: 최신 기능, 불안정할 수 있음
    # legacy_470: 구형 GPU용 (GTX 600/700 시리즈)
    # production: 장기 지원 버전
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Prime 설정 (노트북 - Intel/AMD + NVIDIA 듀얼 GPU)
    # ================================================
    # 노트북에 내장 그래픽 + NVIDIA GPU가 있는 경우 설정
    # lspci | grep -E "VGA|3D" 명령으로 GPU 확인 후 설정

    # prime = {
    #   # offload 모드: 평소에는 내장 GPU, 필요할 때만 NVIDIA 사용
    #   # 배터리 수명 최대화
    #   offload = {
    #     enable = true;
    #     enableOffloadCmd = true;  # nvidia-offload 명령 추가
    #   };
    #
    #   # sync 모드: 항상 NVIDIA GPU 사용 (성능 최대화, 배터리 빠름)
    #   # sync.enable = true;
    #
    #   # GPU 버스 ID 지정 (lspci로 확인)
    #   # 예시: lspci | grep -E "VGA|3D" 결과
    #   # 00:02.0 VGA compatible controller: Intel ...
    #   # 01:00.0 3D controller: NVIDIA ...
    #   intelBusId = "PCI:0:2:0";    # Intel GPU
    #   nvidiaBusId = "PCI:1:0:0";   # NVIDIA GPU
    # };
  };

  # X11 디스플레이 서버 드라이버 설정
  services.xserver.videoDrivers = [ "nvidia" ];

  # 하드웨어 가속 (OpenGL) 설정
  # ===========================
  hardware.opengl = {
    enable = true;

    # 32비트 애플리케이션 지원
    # Steam 게임, Wine 등에서 필요
    driSupport = true;
    driSupport32Bit = true;

    # 추가 OpenGL 패키지
    extraPackages = with pkgs; [
      vaapiVdpau     # VA-API (비디오 가속)
      libvdpau-va-gl # VDPAU (비디오 가속)
    ];
  };

  # Docker NVIDIA 지원
  # ==================
  # NVIDIA Container Toolkit 활성화
  # Docker에서 GPU를 사용할 수 있게 함
  virtualisation.docker.enableNvidia = true;
  hardware.nvidia-container-toolkit.enable = true;

  # CUDA 및 개발 도구
  # =================
  # CUDA로 개발하는 경우 필요한 패키지들
  environment.systemPackages = with pkgs; [
    # NVIDIA 모니터링 도구
    nvtopPackages.full   # GPU 사용량 실시간 모니터링 (htop 스타일)
    nvidia-smi           # NVIDIA System Management Interface

    # CUDA 개발 도구 (필요시 주석 해제)
    # cudatoolkit        # CUDA 컴파일러 및 라이브러리
    # cudnn              # cuDNN (딥러닝용)

    # 유틸리티
    pciutils             # lspci 명령 (GPU 정보 확인)
    glxinfo              # OpenGL 정보 확인
  ];

  # 환경 변수 설정
  # =============
  environment.sessionVariables = {
    # CUDA 관련 환경 변수 (개발 시 필요)
    # CUDA_PATH = "${pkgs.cudatoolkit}";
    # CUDA_HOME = "${pkgs.cudatoolkit}";

    # Wayland에서 NVIDIA 사용 시 필요
    # GBM_BACKEND = "nvidia-drm";
    # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # WLR_NO_HARDWARE_CURSORS = "1";  # Wayland 커서 문제 해결
  };

  # 부트 옵션 (선택사항)
  # ===================
  # 특정 문제 해결용 커널 파라미터
  # boot.kernelParams = [
  #   "nvidia-drm.modeset=1"           # KMS 활성화
  #   "nvidia.NVreg_PreserveVideoMemoryAllocations=1"  # 절전 모드 개선
  # ];

  # 초기 램디스크에 NVIDIA 모듈 포함 (부팅 개선)
  # boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
}
