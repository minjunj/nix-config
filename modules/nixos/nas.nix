# NAS configuration for SMB/CIFS mounting
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.nas;
in {
  options.my.nas = {
    mountPoint = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/share";
      description = "Local mount point for the NAS share.";
    };

    device = lib.mkOption {
      type = lib.types.str;
      default = "//192.168.0.18/share";
      description = "SMB/CIFS device path for the NAS share.";
    };

    credentialsFile = lib.mkOption {
      type = lib.types.str;
      default = "/home/minjunj/nix-config/secrets/smb-secret";
      description = "Runtime path to the SMB credentials file.";
    };
  };

  config = {
    # For mount.cifs, required unless domain name resolution is not needed.
    environment.systemPackages = [pkgs.cifs-utils];
    fileSystems.${cfg.mountPoint} = {
      device = cfg.device;
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

      in ["${automount_opts},credentials=${cfg.credentialsFile}"];
    };
  };
}
