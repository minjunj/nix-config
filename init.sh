#!/bin/bash

apt install -y curl git

# Nix 설치
sh <(curl -L https://nixos.org/nix/install) --daemon

# 쉘 재시작 안내
echo "Nix가 설치되었습니다. 새 터미널을 열거나 다음 명령을 실행하세요:"
echo "  . /etc/profile.d/nix.sh"

# 사용자 확인 후 계속 진행
read -p "Nix 환경을 로드했으면 Enter 키를 눌러 계속하세요..."

# nix 명령이 있는지 확인
if ! command -v nix &> /dev/null; then
    echo "오류: nix 명령을 찾을 수 없습니다. 쉘을 재시작하거나 환경을 로드하세요."
    echo "다음 명령을 실행하세요: . /etc/profile.d/nix.sh"
    exit 1
fi

# 실험적 기능 활성화 설정
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

echo "설치가 완료되었습니다. nix 및 flakes 기능이 활성화되었습니다."
echo "새 터미널을 열어 'nix --version'을 실행하여 설치를 확인하세요."
