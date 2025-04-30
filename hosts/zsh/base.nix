{ pkgs, ... }:

{
  # zsh를 설치
  environment.systemPackages = with pkgs; [
    zsh
  ];

  programs.zsh = {
    enable = true;

    # oh-my-zsh 설정
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" ];
      theme = "";
    };
  };
}
