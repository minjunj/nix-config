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
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };
  };

  environment.systemPackages = [
    pkgs.zsh-powerlevel10k
  ];
}