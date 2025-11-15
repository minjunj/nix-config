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
    extraGroups = ["wheel" "networkmanager"];
  };

  # home-manager configuration for minjunj
  home-manager.users.minjunj = {
    home = {
      username = "minjunj";
      homeDirectory = "/home/minjunj";
      stateVersion = "25.05";
    };

    # User packages
    home.packages = with pkgs; [
      curl
      vim
      wget
      htop
    ];

    programs = {
      home-manager.enable = true;
      git = {
        enable = true;
        userName = "minjunj";
        userEmail = "minjun_jo@gm.gist.ac.kr";
      };
      plasma = {
        enable = true;
        workspace = {
          clickItemTo = "select";
          lookAndFeel = "org.kde.breezedark.desktop";
          cursor.theme = "Bibata-Modern-Ice";
          iconTheme = "Papirus-Dark";
        };
      };
    };

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";
  };
}
