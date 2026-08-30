# NAS configuration for SMB/CIFS mounting
{
  config,
  lib,
  pkgs,
  utils,
  ...
}: let
  cfg = config.my.nas;
  onePasswordVault = "Personal";
  onePasswordItem = "nas-nix";
  usernameField = "username";
  passwordField = "password";
  opBin = "/run/wrappers/bin/op";
  mkSecretRef = field:
    "op://${onePasswordVault}/${onePasswordItem}/${field}";
  usernameRef = mkSecretRef usernameField;
  passwordRef = mkSecretRef passwordField;
  mountUnit = "${utils.escapeSystemdPath cfg.mountPoint}.mount";
  writeCredentials = ''
    set -eu

    credentials_file=${lib.escapeShellArg cfg.credentialsFile}
    credentials_dir="$(${pkgs.coreutils}/bin/dirname -- "$credentials_file")"

    ${pkgs.coreutils}/bin/install -d -m 700 "$credentials_dir"
    umask 077

    tmp="$(${pkgs.coreutils}/bin/mktemp "$credentials_dir/.smb-credentials.XXXXXX")"
    cleanup() {
      ${pkgs.coreutils}/bin/rm -f "$tmp"
    }
    trap cleanup EXIT

    username="$(${opBin} read ${lib.escapeShellArg usernameRef})"
    password="$(${opBin} read ${lib.escapeShellArg passwordRef})"

    {
      printf 'username=%s\n' "$username"
      printf 'password=%s\n' "$password"
    } > "$tmp"

    ${pkgs.coreutils}/bin/chmod 600 "$tmp"
    ${pkgs.coreutils}/bin/mv -f "$tmp" "$credentials_file"
    trap - EXIT
  '';
  writeCredentialsScript = pkgs.writeShellScript "write-nas-smb-credentials" writeCredentials;
  nasConnect = pkgs.writeShellApplication {
    name = "nas-connect";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.systemd
      pkgs.util-linux
    ];
    text = ''
      ${writeCredentials}

      mount_point=${lib.escapeShellArg cfg.mountPoint}

      if findmnt --mountpoint "$mount_point" >/dev/null; then
        echo "$mount_point is already mounted"
        exit 0
      fi

      /run/wrappers/bin/sudo systemctl reset-failed ${lib.escapeShellArg mountUnit} || true
      /run/wrappers/bin/sudo mount "$mount_point"
      findmnt --mountpoint "$mount_point"
    '';
  };
  nasDisconnect = pkgs.writeShellApplication {
    name = "nas-disconnect";
    runtimeInputs = [
      pkgs.util-linux
    ];
    text = ''
      mount_point=${lib.escapeShellArg cfg.mountPoint}

      if ! findmnt --mountpoint "$mount_point" >/dev/null; then
        echo "$mount_point is not mounted"
        exit 0
      fi

      /run/wrappers/bin/sudo umount "$mount_point"
    '';
  };
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

    accountName = lib.mkOption {
      type = lib.types.str;
      default = "minjunj";
      description = "User account whose 1Password session writes the SMB credentials file.";
    };

    credentialsFile = lib.mkOption {
      type = lib.types.str;
      default = "/home/${cfg.accountName}/.local/share/nas/smb-credentials";
      description = "Runtime path to the SMB credentials file.";
    };
  };

  config = {
    # For mount.cifs, required unless domain name resolution is not needed.
    environment.systemPackages = [
      pkgs.cifs-utils
      nasConnect
      nasDisconnect
    ];

    home-manager.users.${cfg.accountName}.systemd.user.services.nas-smb-credentials = {
      Unit.Description = "Write NAS SMB credentials from 1Password";

      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = writeCredentialsScript;
      };
    };

    fileSystems.${cfg.mountPoint} = {
      device = cfg.device;
      fsType = "cifs";
      # Keep this manual: run `nas-connect` after unlocking 1Password.
      options = [
        "noauto"
        "x-systemd.device-timeout=5s"
        "x-systemd.mount-timeout=5s"
        "credentials=${cfg.credentialsFile}"
      ];
    };
  };
}
