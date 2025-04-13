{ config, pkgs, ... }:

{
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  home.stateVersion = "23.11";

  # 설치할 패키지들
  home.packages = with pkgs; [
    # 기본 도구들
    git
    vim
    curl
    wget
    htop
    
    # 필요한 패키지를 더 추가하세요
    # firefox
    # vscode
    # 기타 등등
  ];

  # 프로그램별 설정
  programs = {
    bash = {
      enable = true;
      shellAliases = {
        ll = "ls -l";
        update = "sudo apt update && sudo apt upgrade";
      };
    };
    
    git = {
      enable = true;
      userName = "minjunj";
      userEmail = "minjun_jo@gm.gist.ac.kr";
    };
    
    # 필요한 프로그램 설정을 더 추가하세요
  };

  # Home Manager가 자신을 관리하도록 허용
  programs.home-manager.enable = true;
}
