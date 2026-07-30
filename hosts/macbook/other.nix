# MacBook/Asahi desktop packages. Keep this close to the desktop host's
# package set, but leave out NVIDIA, Steam, Proton, and Godot.
{
  inputs,
  pkgs,
  ...
}: {
  home-manager.sharedModules = [{
    home.packages = with pkgs; [
      geeqie
      vscode-fhs
    ];
  }];

  environment.systemPackages =
    (with pkgs; [
      claude-code
      codex
      discord
      fuzzel
      ghostty
      inputs.noctalia.packages.${pkgs.system}.default
    ]);

  programs.ssh = {
    extraConfig = ''
      Host *
        SetEnv TERM=xterm-256color
    '';
  };
}
