{
  lib,
  ...
}: {
  hardware.asahi.enable = true;
  hardware.asahi.extractPeripheralFirmware = true;
  hardware.asahi.peripheralFirmwareDirectory = /mnt/boot/vendorfw;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.initrd.kernelModules = [
    "uas"
    "usb-storage"
  ];

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
}
