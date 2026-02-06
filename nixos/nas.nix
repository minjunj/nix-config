# NAS configuration for SMB/CIFS mounting
{
  config,
  lib,
  pkgs,
  ...
}: {
  # Install CIFS utilities
  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

  fileSystems."/nas/share" = {
    device = "//192.168.0.18/share";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

    in ["${automount_opts},credentials=/home/minjunj/nix-config/secret/smb-secret,uid=1000,gid=100"];
  };
}
