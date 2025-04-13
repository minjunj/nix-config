{ config, pkgs, ... }:

{
  home.username = "user";
  home.homeDirectory = "/home/user";
  home.stateVersion = "23.11";

  # 설치할 패키지들
  home.packages = with pkgs; [
    git
    vim
    curl
    wget
    htop
  ];

  # zsh 설정
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    
    # oh-my-zsh 설정 (선택사항)
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" ];
      theme = "robbyrussell";  # 또는 다른 테마
    };
    
    # 추가 zsh 설정
    initExtra = ''
      # 여기에 추가 zsh 설정 입력
      alias ll='ls -l'
      alias update='sudo apt update && sudo apt upgrade'
    '';
  };
  
  # 기본 셸로 zsh 설정
  programs.bash.enable = false;  # bash 설정 비활성화
  
  # Git 설정은 그대로 유지
  programs.git = {
    enable = true;
    userName = "minjunj";
    userEmail = "minjun_jo@gm.gist.ac.kr";
  };

  # Home Manager가 자신을 관리하도록 허용
  programs.home-manager.enable = true;
}


# zsh 설정 chsh -s $(which zsh)
