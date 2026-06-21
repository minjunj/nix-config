{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.shell.zsh;
in {
  options.my.shell.zsh = {
    enableOnePasswordAgent = lib.mkEnableOption "1Password SSH agent integration";
  };

  config = {
    users.defaultUserShell = pkgs.zsh;

    programs.zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      promptInit =
        ''
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
          [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

          if command -v direnv >/dev/null 2>&1; then
            eval "$(direnv hook zsh)"
          fi
        ''
        + lib.optionalString cfg.enableOnePasswordAgent ''

          export SSH_AUTH_SOCK=~/.1password/agent.sock
        '';
      shellAliases = {
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
      ohMyZsh = {
        enable = true;
        plugins = ["git"];
      };
    };

    environment.systemPackages = [
      pkgs.zsh-powerlevel10k
    ];
  };
}
