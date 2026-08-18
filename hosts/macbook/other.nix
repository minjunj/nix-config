# MacBook/Asahi desktop packages. Keep this close to the desktop host's
# package set, but leave out NVIDIA, Steam, Proton, and Godot.
{
  inputs,
  lib,
  pkgs,
  ...
}: {
  home-manager.sharedModules = [{
    home.packages =
      (with pkgs; [
        geeqie
      ])
      ++ lib.optionals pkgs.stdenv.hostPlatform.isx86_64 [
        pkgs.vscode-fhs
      ];
  }];

  environment.systemPackages =
    (with pkgs; [
      claude-code
      codex
      fuzzel
      ghostty
      inputs.noctalia.packages.${pkgs.system}.default
    ])
    ++ lib.optionals pkgs.stdenv.hostPlatform.isx86_64 [
      pkgs.discord
    ];

  programs.ssh = {
    extraConfig = ''
      Host *
        SetEnv TERM=xterm-256color
    '';
  };
}
