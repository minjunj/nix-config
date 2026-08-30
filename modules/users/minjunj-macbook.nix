{
  lib,
  pkgs,
  ...
}: {
  # NixOS user account configuration for MacBook/Asahi hosts.
  users.users.minjunj = {
    initialPassword = "1234";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [];
    extraGroups = ["wheel" "networkmanager" "docker"];
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  home-manager.users.minjunj = {
    imports = [
      ../apps/fcitx5.nix
    ];

    xdg.configFile."niri/config.kdl".source = ../desktop/window_manager/tiling/niri/config.kdl;

    home = {
      username = "minjunj";
      homeDirectory = "/home/minjunj";
      stateVersion = "25.05";

      file.".cache/noctalia/wallpapers.json" = {
        text = builtins.toJSON {
          defaultWallpaper = "/home/minjunj/nix-config/assets/gup2.jpg";
        };
      };
    };

    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "minjunj";
          email = "minjun_jo@gm.gist.ac.kr";
          signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC+JrIS2J0hYdsxDy/fSqMgiHGvMFWFgkup2ektW7YoN";
        };
        gpg = {
          format = "ssh";
        };
        "gpg \"ssh\"" = {
          program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
        };
        commit = {
          gpgsign = true;
        };
      };
    };
  };
}
