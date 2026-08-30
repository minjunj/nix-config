{
  lib,
  ...
}: {
  hardware.asahi.enable = true;
  hardware.asahi.extractPeripheralFirmware = true;
  hardware.asahi.peripheralFirmwareDirectory = /boot/vendorfw;

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.graceful = true;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.initrd.kernelModules = [
    "uas"
    "usb-storage"
  ];

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
}
