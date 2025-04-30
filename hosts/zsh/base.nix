{ pkgs, ... }:

{
  # zsh를 설치
  environment.systemPackages = with pkgs; [
    zsh
    zsh-powerlevel10k
  ];

  programs.zsh = {
    enable = true;

    # oh-my-zsh 설정
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" ];
      theme = "powerlevel10k/powerlevel10k";
    };
  };
}
