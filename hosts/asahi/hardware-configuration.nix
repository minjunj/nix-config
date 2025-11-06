# hardware-configuration.nix (Asahi Linux)
# Apple Silicon Mac 하드웨어 설정
# 실제 설치 시 nixos-generate-config로 재생성 필요

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # 부트 설정 (ARM64)
  boot.initrd.availableKernelModules = [
    "usb_storage"
    "usbhid"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # 파일시스템 설정
  # ===============
  # 실제 설치 시 파티션 UUID로 교체 필요
  # blkid 명령어로 확인

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/XXXX-XXXX";
    fsType = "vfat";
  };

  # 스왑 설정 (선택사항)
  # swapDevices = [ ];

  # ARM64 아키텍처 설정
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
