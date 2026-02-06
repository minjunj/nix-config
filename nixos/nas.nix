# NAS configuration for SMB/CIFS mounting
{
  config,
  lib,
  pkgs,
  ...
}: {
  # For mount.cifs, required unless domain name resolution is not needed.
  environment.systemPackages = [ pkgs.cifs-utils ];
  fileSystems."/mnt/share" = {
    device = "//192.168.0.18/share";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

    in ["${automount_opts},credentials=/home/minjunj/nix-config/secret/smb-secret"];
  };
}
