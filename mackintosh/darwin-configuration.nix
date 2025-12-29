# macOS nix-darwin configuration
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./modules/common.nix
    ./modules/system-settings.nix
    inputs.home-manager.darwinModules.home-manager
    ./home-manager.nix
  ];

  # Nix configuration
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

  # nixpkgs configuration
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  # User configuration
  users.users.minjunj = {
    name = "minjunj";
    home = "/Users/minjunj";
  };

  # Primary user for system defaults
  system.primaryUser = "minjunj";

  # System-level packages
  environment.systemPackages = with pkgs; [
    curl
    vim
    wget
    htop
    neofetch
  ];

  # Homebrew configuration
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };

    # Homebrew packages
    brews = [
      "git"
    ];
  };

  # home-manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility
  system.stateVersion = 5;
}