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
    options = [
      "credentials=/home/minjunj/nix-config/secret/smb-credentials"
      "uid=1000"          # 파일 소유자를 minjunj로 설정
      "gid=100"           # 그룹을 users로 설정
      "file_mode=0644"    # 파일 권한
      "dir_mode=0755"     # 디렉토리 권한
      "iocharset=utf8"    # UTF-8 인코딩
    ];
  };

  systemd.tmpfiles.rules = [
    "d /nas/share 0755 root root -"
  ];
}
