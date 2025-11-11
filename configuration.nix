{ config, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  users.users.alice = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "input" "seat" ];
    initialPassword = "test";
  };

  environment.systemPackages = with pkgs; [
    cowsay
    lolcat
  ];

  # 자동으로 Sway 실행
  environment.loginShellInit = ''
    if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
      exec sway
    fi
  '';

  system.stateVersion = "24.05";
}