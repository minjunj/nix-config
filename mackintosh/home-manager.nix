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
      tree
      jq
      asdf-vm
      kubectl
      kubectx
      awscli2
    ];


    # Enable home-manager
    programs.home-manager.enable = true;
  };
}
