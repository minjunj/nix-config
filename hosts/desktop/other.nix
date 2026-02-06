# Common NixOS configuration shared across all hosts
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # Common home-manager configuration
  # This provides shared packages and settings for all users
  home-manager.sharedModules = [{
    # Common packages for all users
    home.packages = with pkgs; [
      # For Desktop. (will be ignored on servers)
      geeqie
      prismlauncher # Minecraft launcher
    ];
    }];
}
