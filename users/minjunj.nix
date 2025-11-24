{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # NixOS user account configuration
  users.users.minjunj = {
    initialPassword = "1234";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [];
    extraGroups = ["wheel" "networkmanager" "docker"];
  };

  fonts.packages = with pkgs; [
  noto-fonts
  noto-fonts-cjk-sans
  noto-fonts-emoji
  ];

  environment.systemPackages = [
    pkgs.discord
  ];

  # home-manager configuration for minjunj
  home-manager.users.minjunj = {
    imports = [
      ../kvm/fcitx5.nix
      ../jobgut/kakaotalk.nix
    ];

    home = {
      username = "minjunj";
      homeDirectory = "/home/minjunj";
      stateVersion = "25.05";

      # NVIDIA GPU environment variables (auto-enabled when nvidia.nix is imported)
      sessionVariables = lib.mkIf config.hardware.nvidia.modesetting.enable {
        LIBVA_DRIVER_NAME = "nvidia";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        NVD_BACKEND = "direct";
        GBM_BACKEND = "nvidia-drm";
      };
    };

    # User-specific git configuration
    programs.git = {
      enable = true;
      userName = "minjunj";
      userEmail = "minjun_jo@gm.gist.ac.kr";

      extraConfig = {
        gpg = {
          format = "ssh";
        };
        "gpg \"ssh\"" = {
          program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
        };
        commit = {
          gpgsign = true;
        };

        user = {
          signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC+JrIS2J0hYdsxDy/fSqMgiHGvMFWFgkup2ektW7YoN";
        };
      };
    };
  };
}
