{
  config,
  lib,
  pkgs,
  ...
}: {
  users.users.nuc_n100 = {
    initialPassword = "1234";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [ 
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAR2RBICNZijk4NvRQvtuSo6zmPlcTnQtd1/pZ2k5KEJ"
    ];
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
