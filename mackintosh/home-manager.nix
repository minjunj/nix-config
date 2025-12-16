# macOS home-manager configuration for minjunj
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # home-manager configuration for minjunj user
  home-manager.users.minjunj = {
    home = {
      username = "minjunj";
      homeDirectory = "/Users/minjunj";
      stateVersion = "25.05";
    };

    # Powerlevel10k configuration file
    home.file.".p10k.zsh".source = ../zsh/p10k.zsh;

    # macOS compatible packages
    home.packages = with pkgs; [
      curl
      vim
      wget
      htop
      neofetch
      # Development tools
      git
      # Terminal utilities
      tree
      ripgrep
      fd
      bat
      eza
    ];


    # Enable home-manager
    programs.home-manager.enable = true;
  };
}