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
    promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
    shellAliases = {
      # Git aliases
      g-s = "git status";
      g-a = "git add . && git status";
      g-c = "git commit";
      g-p = "git push";
      g-l = "git pull origin";
      g-d = "git diff";

      # NixOS specific
      rebuild = "sudo nixos-rebuild switch --flake .";
      update = "nix flake update";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };
  };

  environment.systemPackages = [
    pkgs.zsh-powerlevel10k
  ];
}