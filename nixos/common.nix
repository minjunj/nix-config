# Common NixOS configuration shared across all hosts
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./zsh.nix
  ];

  nixpkgs = {
    overlays = [];
    config = {
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # SSH server configuration
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Common home-manager configuration
  # This provides shared packages and settings for all users
  home-manager.sharedModules = [{
    imports = [
      ../theme/plasma-theme.nix
    ];

    # Common packages for all users
    home.packages = with pkgs; [
      curl
      vim
      wget
      htop
      google-chrome
      vscode-fhs # vscode virtualization
      asdf-vm
    ];

    # Enable plasma for all users
    programs.plasma = {
      enable = true;
    };

    # Enable home-manager
    programs.home-manager.enable = true;

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";
  }];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
