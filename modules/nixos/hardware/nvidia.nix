{ config, lib, ... }:
{
  # ===============================================================================================
  # for Nvidia GPU
  # https://wiki.nixos.org/wiki/NVIDIA
  # https://wiki.hyprland.org/Nvidia/
  # ===============================================================================================

  boot.kernelParams = [
    # Since NVIDIA does not load kernel mode setting by default,
    # enabling it is required to make Wayland compositors function properly.
    "nvidia-drm.fbdev=1"
  ];
  services.xserver.videoDrivers = [ "nvidia" ]; # will install nvidia-vaapi-driver by default
  hardware.nvidia = {
    # Open-source kernel modules are preferred over and planned to steadily replace proprietary modules
    open = true;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/os-specific/linux/nvidia-x11/default.nix
    # package = config.boot.kernelPackages.nvidiaPackages.production;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "595.80";
      sha256_64bit = "sha256-PVTIP+B/01c/8M66hXTAYTLg9T2Hy9u1gq43K7TF1Hg=";
      sha256_aarch64 = "sha256-62uqbRsF+dizUqvXhBfmVFeV2gg4BH6f7kOta+uMMuk=";
      openSha256 = "sha256-nonwYYPItHeMC/5Ox/TlWhjiddMPu4PLqNhgIg+bfW8=";
      settingsSha256 = "sha256-AtzYTz7kbmj3vxmBQTC0eAjM3b2I259y1tdxq90n9YU=";
      persistencedSha256 = "sha256-WL57kKFWeRW0oPktp6afkUb5Om9MCGAvKWctk5yiyIA=";
    };

    # required by most wayland compositors!
    modesetting.enable = true;
    powerManagement.enable = true;
  };

  # NOTE: hardware 설정으로 nvidia docker를 활성화한다면 --device nvidia.com/gpu=all 를 이용.
  hardware.nvidia-container-toolkit.enable = true;
  hardware.graphics = {
    enable = true;
    # needed by nvidia-docker
    enable32Bit = true;
  };

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      experimental = true;
      default-address-pools = [
        {
          base = "172.30.0.0/16";
          size = 24;
        }
      ];
    };
  };

  nixpkgs.overlays = [
    (_: super: {
      # ffmpeg-full = super.ffmpeg-full.override {
      #   withNvcodec = true;
      # };
    })
  ];

  services.sunshine.settings = {
    max_bitrate = 20000; # in Kbps
    # NVIDIA NVENC Encoder
    nvenc_preset = 3; # 1(fastest + worst quality) - 7(slowest + best quality)
    nvenc_twopass = "full_res"; # quarter_res / full_res.
  };
}
