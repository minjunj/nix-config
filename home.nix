# home.nix
# Home Manager 설정 - 사용자별 프로그램 및 dotfiles 관리
# 시스템 설정은 configuration.nix, 사용자 설정은 여기서!

{ config, pkgs, lib, hostname, ... }:

{
  # Home Manager 기본 설정
  home.username = "user";
  home.homeDirectory = "/home/user";

  # Home Manager 버전 (변경하지 말 것)
  home.stateVersion = "24.05";

  # 사용자 홈에 설치할 패키지들
  # ===========================
  home.packages = with pkgs; [
    # 개발 도구
    asdf-vm          # 버전 매니저 (terraform, node 등)
    direnv           # 디렉토리별 환경 변수 자동 로드
    nix-direnv       # direnv + Nix 통합

    # CLI 유틸리티
    fzf              # 퍼지 파인더 (파일/명령어 검색)
    ripgrep          # 빠른 grep 대체
    fd               # 빠른 find 대체
    bat              # cat 대체 (구문 강조)
    eza              # ls 대체 (더 예쁜 출력)
    jq               # JSON 파서

    # 터미널 개선
    tmux             # 터미널 멀티플렉서
    neofetch         # 시스템 정보 표시

    # 파일 관리
    mc               # Midnight Commander (TUI 파일 관리자)
  ];

  # ZSH 설정 (oh-my-zsh 포함)
  # =========================
  programs.zsh = {
    enable = true;

    # oh-my-zsh 설정
    oh-my-zsh = {
      enable = true;

      # 테마 선택
      # "robbyrussell" - 기본 테마
      # "agnoster" - 인기 있는 파워라인 테마
      # "powerlevel10k/powerlevel10k" - 가장 인기 있는 테마 (별도 설치 필요)
      theme = "agnoster";

      # oh-my-zsh 플러그인들
      plugins = [
        "git"              # git 단축 명령어 (gst, gco 등)
        "docker"           # docker 자동완성
        "docker-compose"   # docker-compose 자동완성
        "kubectl"          # kubectl 자동완성
        "terraform"        # terraform 자동완성
        "asdf"             # asdf 통합
        "direnv"           # direnv 통합
        "fzf"              # fzf 통합
        "history"          # history 검색 개선
        "colored-man-pages"  # man 페이지 색상 강조
        "command-not-found"  # 명령어 못 찾을 때 설치 제안
      ];
    };

    # zsh 추가 설정
    initExtra = ''
      # asdf 초기화
      . ${pkgs.asdf-vm}/share/asdf-vm/asdf.sh

      # direnv 초기화
      eval "$(direnv hook zsh)"

      # fzf 키 바인딩
      # Ctrl+R: 명령어 히스토리 검색
      # Ctrl+T: 파일 검색
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh

      # 편리한 alias 모음
      alias ll='eza -l --icons'                    # 상세 목록
      alias la='eza -la --icons'                   # 숨김 파일 포함
      alias lt='eza --tree --level=2 --icons'      # 트리 구조
      alias cat='bat --style=plain'                # cat 대신 bat
      alias grep='rg'                              # grep 대신 ripgrep
      alias find='fd'                              # find 대신 fd

      # Git alias (oh-my-zsh git 플러그인 외 추가)
      alias gs='git status'
      alias gc='git commit'
      alias gp='git push'
      alias gl='git pull'

      # Docker alias
      alias dc='docker-compose'
      alias dps='docker ps'
      alias dlog='docker logs -f'

      # workspace 빠른 이동
      alias ws='cd ~/workspace'
      alias scratch='cd ~/workspace/scratch'
    '';

    # 환경 변수 설정
    sessionVariables = {
      # 기본 에디터
      EDITOR = "vim";
      VISUAL = "vim";

      # asdf 데이터 디렉토리
      ASDF_DATA_DIR = "$HOME/.asdf";
    };

    # 히스토리 설정
    history = {
      size = 10000;              # 메모리에 저장할 명령어 수
      save = 10000;              # 파일에 저장할 명령어 수
      path = "$HOME/.zsh_history";
      ignoreDups = true;         # 중복 명령어 무시
      share = true;              # 여러 터미널 간 히스토리 공유
    };
  };

  # Git 설정
  # ========
  programs.git = {
    enable = true;
    userName = "Your Name";           # 본인 이름으로 변경
    userEmail = "your@email.com";     # 본인 이메일로 변경

    # Git alias
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
    };

    # Git 추가 설정
    extraConfig = {
      init.defaultBranch = "main";     # 기본 브랜치 이름
      pull.rebase = false;              # pull 시 merge 사용
      core.editor = "vim";              # 기본 에디터
    };
  };

  # direnv 설정 (프로젝트별 환경 자동 로드)
  # ======================================
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;  # Nix 통합
    enableZshIntegration = true;
  };

  # 터미널 에뮬레이터 설정 (선택사항)
  # ===============================
  # GNOME Terminal 대신 더 기능이 많은 터미널
  # programs.kitty = {
  #   enable = true;
  #   theme = "Tokyo Night";
  #   font = {
  #     name = "FiraCode Nerd Font";
  #     size = 12;
  #   };
  # };

  # VSCode 설정
  # ===========
  programs.vscode = {
    enable = true;
    # VSCode 확장 설치 (선언적으로 관리)
    extensions = with pkgs.vscode-extensions; [
      # 필수 확장들
      ms-vscode-remote.remote-ssh        # SSH 원격 개발
      ms-azuretools.vscode-docker        # Docker 지원

      # 언어 지원
      hashicorp.terraform                # Terraform
      # ms-python.python                 # Python (필요시 주석 해제)
      # golang.go                        # Go (필요시 주석 해제)

      # 테마
      dracula-theme.theme-dracula        # Dracula 테마

      # 유틸리티
      eamodio.gitlens                    # Git 강화
      # esbenp.prettier-vscode           # 코드 포맷터 (필요시 주석 해제)
    ];

    # VSCode 설정 (settings.json)
    userSettings = {
      "editor.fontSize" = 14;
      "editor.fontFamily" = "'Fira Code', 'monospace'";
      "editor.fontLigatures" = true;     # 리가처 활성화
      "editor.tabSize" = 2;
      "editor.formatOnSave" = true;      # 저장 시 자동 포맷
      "files.autoSave" = "afterDelay";   # 자동 저장
      "terminal.integrated.fontSize" = 13;
      "workbench.colorTheme" = "Dracula";
    };
  };

  # Chrome 브라우저 (system에서 설치)
  # ================================
  # Chrome은 home.nix가 아닌 아래 파일에서 설치:
  # modules/base.nix 또는 각 호스트의 configuration.nix

  # workspace 디렉토리 관리
  # ========================
  home.file = {
    # scratch 폴더에 README 생성 (설명용)
    "workspace/scratch/README.md".text = ''
      # Scratch Directory

      이 디렉토리는 임시 작업용입니다.
      - 테스트 코드
      - 임시 다운로드
      - 실험적인 프로젝트

      Git에 추적되지 않으며, 자유롭게 사용하세요.
    '';

    # .gitignore에 scratch 추가
    "workspace/.gitignore".text = ''
      # 임시 작업 폴더
      scratch/

      # 일반적인 임시 파일들
      *.tmp
      *.log
      .DS_Store
    '';
  };

  # Home Manager가 자동으로 관리하도록 설정
  programs.home-manager.enable = true;
}
