# VS Code 설치 스크립트 함수
{ pkgs }:

pkgs.writeShellScriptBin "install-vscode" ''
  #!${pkgs.bash}/bin/bash
  set -e
  echo "Microsoft VS Code 설치를 시작합니다..."
  
  # 필요한 패키지 설치
  sudo apt-get install -y wget gpg apt-transport-https
  
  # Microsoft GPG 키 설치
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  rm -f packages.microsoft.gpg
  
  # VS Code 설치
  sudo apt-get update
  sudo apt-get install -y code
  
  # 설치 확인
  if command -v code &> /dev/null; then
    echo ""
    echo "==============================================="
    echo "🎉 VS Code가 성공적으로 설치되었습니다! 🎉"
    echo "==============================================="
    echo "버전: $(code --version | head -n1)"
    echo ""
    echo "다음 명령어로 현재 디렉토리를 VS Code로 열 수 있습니다:"
    echo "code ."
  else
    echo "⚠️ VS Code 설치에 문제가 발생했습니다."
    exit 1
  fi
''
