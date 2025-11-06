# hardware-configuration.nix
# 이 파일은 NixOS 설치 시 자동으로 생성됩니다
# nixos-generate-config 명령으로 생성 가능
#
# 실제 설치 시 이 내용을 하드웨어에 맞게 교체해야 합니다!
# 지금은 템플릿 예시입니다.

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # 부트 설정
  boot.initrd.availableKernelModules = [
    "xhci_pci"     # USB 3.0 컨트롤러
    "ahci"         # SATA 컨트롤러
    "nvme"         # NVMe SSD
    "usbhid"       # USB 입력 장치
    "usb_storage"  # USB 스토리지
    "sd_mod"       # SD 카드
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];  # Intel CPU 가상화
  boot.extraModulePackages = [ ];

  # 파일시스템 설정
  # ===============
  # 실제 설치 시 아래 내용을 본인의 파티션 UUID로 교체해야 합니다
  # blkid 명령어로 UUID 확인 가능

  fileSystems."/" = {
    # 루트 파일시스템
    device = "/dev/disk/by-uuid/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    # EFI 부트 파티션
    device = "/dev/disk/by-uuid/XXXX-XXXX";
    fsType = "vfat";
  };

  # 스왑 설정 (선택사항)
  # swapDevices = [
  #   { device = "/dev/disk/by-uuid/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"; }
  # ];

  # CPU 마이크로코드 업데이트
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # AMD CPU 사용 시 위 줄을 주석 처리하고 아래 줄 활성화
  # hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # 네트워크 인터페이스
  # networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
}
