{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  users.defaultUserShell = pkgs.zsh;

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" ];
    };
  };
}