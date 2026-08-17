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
      vscode-fhs # vscode virtualization
    ];
  }];

  environment.systemPackages = with pkgs; [
    # godot
    godotPackages_4_6.godot-mono
    godotPackages_4_6.export-templates-mono-bin
    dotnetCorePackages.sdk_8_0
    # proton
    protonplus
    # steam
    steamcmd
    # desktop settings
    discord
    claude-code
    codex
    fuzzel
    ghostty
    inputs.noctalia.packages.${pkgs.system}.default
    # booting disk GUI
    mediawriter
  ];

  programs.steam = {
    enable = true;
  };

  # ghostty 사용 시 ssh할 때 생기는 문제 대응
  programs.ssh = {
    extraConfig = "
      Host *
        SetEnv TERM=xterm-256color
    ";
  };
}
