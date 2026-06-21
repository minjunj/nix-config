{
  config,
  lib,
  pkgs,
  ...
}: {
  users.users.nuc_n100 = {
    initialPassword = "1234";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [];
    extraGroups = ["wheel" "networkmanager" "docker"];
  };

  home-manager.users.nuc_n100 = {
    home = {
      username = "nuc_n100";
      homeDirectory = "/home/nuc_n100";
      stateVersion = "25.05";
    };
  };
}
