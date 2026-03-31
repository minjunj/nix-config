# Common macOS configuration shared across darwin configurations
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # Configure zsh for nix-darwin
  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      export SSH_AUTH_SOCK=~/.1password/agent.sock
    '';
  };

  # Environment aliases for darwin
  environment.shellAliases = {
    # Git aliases
    g-s = "git status";
    g-a = "git add . && git status";
    g-c = "git commit -m";
    g-p = "git push origin";
    g-d = "git diff";
    gpl = "git pull origin";

    # Darwin specific
    darwin-rebuild = "darwin-rebuild switch --flake";
    update = "nix flake update";
  };

  # System packages including powerlevel10k
  environment.systemPackages = with pkgs; [
    zsh-powerlevel10k
  ];

  # Used for backwards compatibility
  system.stateVersion = 5;
}