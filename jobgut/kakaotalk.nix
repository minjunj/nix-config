# https://gist.github.com/Riey/11a06d326bcc41e33d4145fc8ce44bd8 을 기반으로 수정함
{ pkgs, lib, ... }:
let
  winePrefix = "/home/ground/.wine/kakaotalk";
  wineArch = "win32";
  kakaotalkInstallerUrl = "https://app-pc.kakaocdn.net/talk/win32/KakaoTalk_Setup.exe";
  dpi = 192;
  winePkg = pkgs.wineWowPackages.full.override { mingwSupport = false; };

  installerScript = pkgs.writeScript "kakaotalk-install" ''
    #!/usr/bin/env zsh
    set -euo pipefail

    export PATH="${
      pkgs.lib.makeBinPath [
        winePkg
        pkgs.winetricks
        pkgs.icoextract
      ]
    }:$PATH"

    export WINEPREFIX=${winePrefix}
    export WINEDLLOVERRIDES="mscoree,mshtml="
    export WINEARCH=${wineArch}

    # Configure necessary fonts for taskbar right-click menu
    winetricks corefonts cjkfonts

    # Configure HiDPI settings
    HEX_DPI=$(printf '0x%x' ${toString dpi})
    wine reg add "HKLM\System\CurrentControlSet\Hardware Profiles\Current\Software\Fonts" /v LogPixels /t REG_DWORD /d $HEX_DPI /f

    # Disable Wine-Native Menu builder as we've configured it via home-manager
    wine reg add "HKCU\Software\Wine\DllOverrides" /v "winemenubuilder.exe" /t REG_SZ /d "" /f

    TEMP_PATH=$(mktemp -d)
    INSTALLER_PATH="$TEMP_PATH/installer.exe"
    curl -Lo $INSTALLER_PATH ${kakaotalkInstallerUrl}
    wine $INSTALLER_PATH

    icoextract "${winePrefix}/drive_c/Program Files/Kakao/KakaoTalk/KakaoTalk.exe" "${winePrefix}/kakaoTalk.png"
  '';
  installer = pkgs.stdenv.mkDerivation {
    name = "kakaotalk-installer";
    src = installerScript;
    phases = [ "installPhase" ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    installPhase = ''
      #!/usr/env/bin bash

      mkdir -p $out/bin
      cp $src $out/bin/kakaotalk-install
    '';
  };
  executionScript = pkgs.writeScript "kakaotalk" ''
    #!/usr/bin/env zsh
    set -euo pipefail

    export PATH="${
      pkgs.lib.makeBinPath [
        winePkg
      ]
    }:$PATH"

    export WINEPREFIX=${winePrefix}
    export WINEDLLOVERRIDES="mscoree,mshtml="
    export WINEARCH=${wineArch}

    GTK_IM_MODULE=fcitx
    QT_IM_MODULE=fcitx
    XMODIFIERS=@im=fcitx

    wine "${winePrefix}/drive_c/Program Files/Kakao/KakaoTalk/KakaoTalk.exe"
  '';
  runner = pkgs.stdenv.mkDerivation {
    name = "kakaotalk-runner";
    src = executionScript;
    phases = [ "installPhase" ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    installPhase = ''
      #!/usr/env/bin bash

      mkdir -p $out/bin
      cp $src $out/bin/kakaotalk
    '';
  };
in
{
  home.packages = [
    installer
    runner
  ];

  xdg.desktopEntries = {
    kakaoTalkTaskBar = {
      type = "Application";
      name = "KakaoTalk";
      startupNotify = true;
      exec = "${runner}/bin/kakaotalk";
      icon = "${winePrefix}/kakaoTalk.png";
    };
    kakaoTalkMimeTypes = {
      type = "Application";
      name = "KakaoTalk";
      mimeType = [
        "x-scheme-handler/kakaoopen"
        "x-scheme-handler/kakaotalk"
      ];
      exec = "env WINEPREFIX=${winePrefix} ${winePkg}/bin/wine start %u";
      noDisplay = true;
      startupNotify = true;
      icon = "${winePrefix}/kakaoTalk.png";
    };
  };
}
