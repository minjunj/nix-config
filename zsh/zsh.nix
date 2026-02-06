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

      export SSH_AUTH_SOCK=~/.1password/agent.sock

      eval "$(direnv hook zsh)"
    '';
    shellAliases = {
      open = "dolphin";

      kakaotalk = "sudo kakaotalk";
      nix-rebuild = "sudo nixos-rebuild switch --flake"; # .#machinename

      # Git aliases
      g-s = "git status";
      g-a = "git add . && git status";
      g-c = "git commit -m";
      g-p = "git push origin";
      g-d = "git diff";
      gpl = "git pull origin";

      # NixOS specific
      rebuild = "sudo nixos-rebuild switch --flake";
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