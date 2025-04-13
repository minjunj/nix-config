{ config, pkgs, lib, ... }:

let
  # JSON 파일에서 설정 읽기
  userConfig = builtins.fromJSON (builtins.readFile ./config.json);
in
{
  home.username = userConfig.username;
  home.homeDirectory = userConfig.homeDirectory;
  home.stateVersion = "23.11";

  # 설치할 패키지들
  home.packages = with pkgs; [
    git
    vim
    curl
    wget
    htop
    sudo
  ];

  # zsh를 유효한 셸로 등록하는 activation 스크립트
  home.activation = {
    addZshToEtcShells = lib.hm.dag.entryAfter ["writeBoundary"] ''
      ZSH_PATH="$HOME/.nix-profile/bin/zsh"
      if [ -x "$ZSH_PATH" ] && ! grep -q "$ZSH_PATH" /etc/shells; then
        echo "zsh 경로를 /etc/shells에 추가하려면 sudo 암호를 입력하세요"
        echo "$ZSH_PATH" | /usr/bin/sudo tee -a /etc/shells
        echo "zsh가 유효한 셸로 등록되었습니다."
      else
        echo "zsh가 이미 /etc/shells에 등록되어 있거나 실행 가능하지 않습니다."
      fi
    '';
  };

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
      theme = "agnoster";
    };    

    # powerlevel10k 설정
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.fetchFromGitHub {
          owner = "romkatv";
          repo = "powerlevel10k";
          rev = "v1.19.0";  # 최신 버전 또는 원하는 버전
          sha256 = "sha256-+hzjSbbrXr0w1rGHm6m2oZ6pfmD6UUDBfPd7uMg5l5c=";  # 해시값을 적절히 설정
        };
        file = "powerlevel10k.zsh-theme";
      }
    ];

    # 추가 zsh 설정
    initExtra = ''
      # 기존 설정
      alias ll='ls -l'
      alias update='sudo apt update && sudo apt upgrade'
      
      # Powerlevel10k 설정
      # p10k 설정 파일을 불러옴
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
      
      # 또는 인라인으로 기본 설정을 제공
      POWERLEVEL9K_MODE="nerdfont-complete"
      POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
      POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs time)
    '';
  };
  
  # 기본 셸로 zsh 설정
  programs.bash.enable = false;  # bash 설정 비활성화
  
  # Git 설정은 그대로 유지
  programs.git = {
    enable = true;
    userName = userConfig.gitUserName;
    userEmail = userConfig.gitEmail;
  };

  # Home Manager가 자신을 관리하도록 허용
  programs.home-manager.enable = true;
}


# zsh 설정 chsh -s $(which zsh)
