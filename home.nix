{ config, pkgs, lib, ... }:

let
  userConfig = builtins.fromJSON (builtins.readFile ./config.json);
  powerlevel10k = import ./p10k-config.nix { inherit config lib; };
in
{
  home.username = userConfig.username;
  home.homeDirectory = userConfig.homeDirectory;
  home.stateVersion = "23.11";

  # 설치할 패키지들
  home.packages = with pkgs; [
    git
    vim
    nettools
    curl
    wget
    htop
    helm
    kubectl
    kubectx
    awscli2
    jq
    jwt-cli
    asdf-vm
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
    
    # oh-my-zsh 설정
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" ];
      theme = "";
    };    

    # powerlevel10k 설정
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.fetchFromGitHub {
          owner = "romkatv";
          repo = "powerlevel10k";
          rev = "v1.19.0";
          sha256 = "sha256-+hzjSbbrXr0w1rGHm6m2oZ6pfmD6UUDBfPd7uMg5l5c=";
        };
        file = "powerlevel10k.zsh-theme";
      }
    ];
  
    shellAliases = {
      g-a = "git add . && git status";
      g-s = "git switch";
      g-c = "git commit -m";
      g-p = "git push origin";
      g-pu = "git pull";
      ll = "ls -l";
      la = "ls -la";
    };

    # 추가 zsh 설정
    initExtra = ''
      ${powerlevel10k}
      export AWS_PROFILE="default"

      # asdf 로드
      if [ -e "${pkgs.asdf-vm}/share/asdf-vm/asdf.sh" ]; then
        . "${pkgs.asdf-vm}/share/asdf-vm/asdf.sh"
      fi
      
      # asdf 자동완성
      if [ -e "${pkgs.asdf-vm}/share/asdf-vm/completions/asdf.bash" ]; then
        . "${pkgs.asdf-vm}/share/asdf-vm/completions/asdf.bash"
      fi
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

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
    # # 확장 기능 설치
    # extensions = with pkgs.vscode-extensions; [
    #   # 기본 확장 기능
    #   ms-vscode.cpptools                # C/C++ 지원
    #   ms-python.python                  # Python 지원
    #   redhat.java                       # Java 지원
      
    #   # 테마와 아이콘
    #   pkief.material-icon-theme         # 아이콘 테마
      
    #   # 도구
    #   eamodio.gitlens                   # Git 도구
    #   esbenp.prettier-vscode            # 코드 포맷팅
      
    #   # 언어 지원
    #   hashicorp.terraform               # Terraform
    #   jnoortheen.nix-ide                # Nix 언어 지원
    # ];
    
    # # 사용자 설정
    # userSettings = {
    #   "editor.fontFamily" = "'Fira Code', 'Droid Sans Mono', monospace";
    #   "editor.fontSize" = 14;
    #   "editor.tabSize" = 2;
    #   "editor.renderWhitespace" = "boundary";
    #   "editor.minimap.enabled" = false;
    #   "workbench.colorTheme" = "Default Dark+";
    #   "workbench.iconTheme" = "material-icon-theme";
    #   "terminal.integrated.fontFamily" = "'MesloLGS NF'";
    #   "files.autoSave" = "afterDelay";
    #   "files.autoSaveDelay" = 1000;
    # };
    
    # # 키 바인딩 설정
    # keybindings = [
    #   {
    #     key = "ctrl+/";
    #     command = "editor.action.commentLine";
    #     when = "editorTextFocus && !editorReadonly";
    #   }
    # ];
  };

  dconf.settings = {
    # Ubuntu Dock 위치 설정 (left, bottom, right 중 선택)
    "org/gnome/shell/extensions/dash-to-dock" = {
      "dock-position" = "BOTTOM";  # BOTTOM, LEFT, RIGHT 중 하나 선택
      
      # 추가 독 설정 (옵션)
      "extend-height" = true;      # 독이 화면 가장자리를 따라 확장되도록 설정
      "intellihide" = true;        # 창이 독을 가릴 때만 독 숨기기
      "autohide" = true;           # 자동 숨기기 활성화
      "panel-mode" = false;
    };
    
    # 기타 GNOME 설정도 필요하면 여기에 추가
  };
  
  # Home Manager가 자신을 관리하도록 허용
  programs.home-manager.enable = true;
}
