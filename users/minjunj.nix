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
      homeDirectory = "/home/ground";
      stateVersion = "25.05";
    };

    # User-specific git configuration
    programs.git = {
      enable = true;
      userName = "minjunj";
      userEmail = "minjun_jo@gm.gist.ac.kr";
    };
  };
}
