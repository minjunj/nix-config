# gnome-macos-theme.nix
# GNOME 데스크톱을 macOS 스타일로 꾸미는 설정
# WhiteSur 테마 + Dash to Dock으로 macOS 느낌 재현

{ config, pkgs, lib, ... }:

{
  # GNOME 데스크톱 환경은 이미 modules/base.nix에서 활성화됨

  # GNOME 확장 프로그램들
  # ====================
  # GNOME Shell Extensions: GNOME의 기능을 확장하는 애드온들
  environment.systemPackages = with pkgs; [
    # GNOME 설정 도구
    gnome.gnome-tweaks       # 고급 설정 (테마, 폰트, 확장 등)
    dconf-editor              # 시스템 설정 편집기

    # macOS 스타일 확장들
    gnomeExtensions.dash-to-dock          # 독(Dock) 추가 - macOS 하단 앱 런처 같은 것
    gnomeExtensions.blur-my-shell         # 반투명 효과 (macOS 스타일)
    gnomeExtensions.user-themes           # 사용자 테마 적용 가능
    gnomeExtensions.appindicator          # 시스템 트레이 아이콘 (상단바 아이콘들)
    gnomeExtensions.vitals                # CPU/메모리 모니터 (상단바에 표시)
    gnomeExtensions.clipboard-indicator   # 클립보드 히스토리

    # 유용한 추가 확장
    gnomeExtensions.caffeine              # 화면 꺼짐 방지 토글
    gnomeExtensions.sound-output-device-chooser  # 오디오 출력 장치 빠른 전환

    # macOS 스타일 테마 패키지
    # ========================

    # WhiteSur GTK 테마 (macOS Big Sur/Monterey 스타일)
    # 윈도우, 버튼, 메뉴 등의 디자인을 macOS처럼 만듦
    whitesur-gtk-theme

    # WhiteSur 아이콘 테마
    # 파일, 앱 아이콘을 macOS 스타일로
    whitesur-icon-theme

    # 커서 테마
    # macOS 스타일 마우스 커서
    bibata-cursors            # 깔끔한 현대적 커서

    # 폰트 (macOS 기본 폰트들)
    # =======================
    # Apple이 사용하는 San Francisco 폰트와 유사한 폰트들

    # Inter 폰트: SF Pro와 매우 유사한 오픈소스 폰트
    inter

    # SF Pro, SF Mono 등 Apple 폰트를 직접 설치하고 싶다면:
    # 1. Apple 개발자 사이트에서 폰트 다운로드
    # 2. ~/.local/share/fonts/에 복사
    # 3. fc-cache -f -v 실행

    # Nerd Fonts: 아이콘이 포함된 개발자용 폰트
    (nerdfonts.override { fonts = [ "FiraCode" "Hack" "JetBrainsMono" ]; })
  ];

  # dconf 설정 (GNOME 시스템 설정)
  # ==============================
  # dconf: GNOME의 설정을 저장하는 데이터베이스
  # 테마, 확장, UI 설정 등을 명령줄에서 설정 가능

  # 사용자별로 설정을 적용하려면 home.nix에서 설정
  # 시스템 전체 기본값은 여기서 설정

  # programs.dconf.enable = true;  # base.nix에서 이미 활성화

  # GNOME 기본 앱 최소화
  # ===================
  # GNOME이 기본으로 설치하는 불필요한 앱들 제거
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour              # 첫 실행 튜토리얼
    gnome.epiphany          # GNOME 웹 브라우저 (Chrome 쓸거니까 불필요)
    gnome.geary             # 이메일 클라이언트
    gnome.gnome-music       # 음악 플레이어
    # gnome.nautilus        # 파일 관리자 (필요하면 주석 해제)
    # gnome.totem           # 비디오 플레이어 (필요하면 주석 해제)
  ];

  # GDM 로그인 화면 테마 적용
  # ========================
  # 로그인 화면도 macOS 스타일로 꾸미기
  # (선택사항 - 복잡할 수 있어서 일단 주석)
  # programs.gnome.loginScreenBackdrop = ./path/to/wallpaper.jpg;
}

# 추가 설정을 위한 가이드
# =======================
#
# 1. Dash to Dock 설정 (독 위치, 크기 조정)
#    - GNOME Tweaks 또는 dconf-editor에서 설정
#    - 또는 home.nix에서 dconf 설정으로 자동화 가능
#
# 2. 배경화면 변경
#    - home.nix에서 설정하거나
#    - GNOME 설정에서 직접 변경
#
# 3. 테마 적용 방법
#    - GNOME Tweaks 실행
#    - "Appearance" 탭에서:
#      * Applications: WhiteSur-Light 또는 WhiteSur-Dark
#      * Icons: WhiteSur
#      * Cursor: Bibata-Modern-Classic
#      * Shell: WhiteSur-Light 또는 WhiteSur-Dark
#
# 4. Dock 설정 (macOS 스타일로)
#    - Extensions에서 Dash to Dock 설정:
#      * Position: Bottom (하단)
#      * Icon size: 48-64px
#      * Intelligent autohide: ON
#
# 5. 상단바 설정
#    - Tweaks > Top Bar:
#      * Battery Percentage: ON
#      * Clock > Date: ON
#      * Calendar > Week Numbers: OFF
