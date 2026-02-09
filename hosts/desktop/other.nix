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
      geeqie # Image viewer
      yazi # CLI file manager
      prismlauncher # Minecraft launcher
    ];
  }];
}
