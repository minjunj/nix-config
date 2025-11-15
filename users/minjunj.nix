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

    imports = [];

    # User packages
    home.packages = with pkgs; [
      curl
      vim
      wget
      htop
    ];

    # User programs
    programs.home-manager.enable = true;
    programs.git = {
      ebable = true;
      userName = "minjunj";
      userEmail = "minjun_jo@gm.gist.ac.kr";
    }

    # KDE Plasma configuration
    programs.plasma = {
      enable = true;

      # Workspace settings
      workspace = {
        lookAndFeel = "org.kde.breezedark.desktop";
        colorScheme = "BreezeDark";
      };
    };

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";
  };
}
