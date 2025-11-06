#!/usr/bin/env bash
# build-iso.sh
# NixOS 커스텀 ISO 빌드 스크립트

set -e  # 에러 발생 시 중단

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 로그 함수
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 배너 출력
echo "======================================"
echo "  NixOS 커스텀 ISO 빌드 스크립트"
echo "======================================"
echo ""

# Nix 설치 확인
log_info "Nix 설치 확인 중..."
if ! command -v nix &> /dev/null; then
    log_error "Nix가 설치되어 있지 않습니다."
    echo "다음 명령으로 설치하세요:"
    echo "  curl -L https://nixos.org/nix/install | sh"
    exit 1
fi
log_success "Nix 설치 확인됨"

# Flakes 활성화 확인
log_info "Nix Flakes 지원 확인 중..."
if ! nix flake --help &> /dev/null; then
    log_warning "Nix Flakes가 활성화되지 않았습니다."
    log_info "Flakes 활성화 중..."

    mkdir -p ~/.config/nix
    if ! grep -q "experimental-features" ~/.config/nix/nix.conf 2>/dev/null; then
        echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
        log_success "Flakes 활성화 완료"
        log_warning "쉘을 재시작하거나 다음 명령을 실행하세요:"
        echo "  . ~/.nix-profile/etc/profile.d/nix.sh"
        exit 0
    fi
fi
log_success "Flakes 지원 확인됨"

# 디스크 공간 확인
log_info "디스크 공간 확인 중..."
AVAILABLE_SPACE=$(df -BG . | tail -1 | awk '{print $4}' | sed 's/G//')
REQUIRED_SPACE=10

if [ "$AVAILABLE_SPACE" -lt "$REQUIRED_SPACE" ]; then
    log_warning "디스크 공간이 부족할 수 있습니다."
    log_warning "사용 가능: ${AVAILABLE_SPACE}GB, 권장: ${REQUIRED_SPACE}GB+"
    read -p "계속하시겠습니까? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "빌드 취소됨"
        exit 0
    fi
else
    log_success "충분한 디스크 공간 확인됨 (${AVAILABLE_SPACE}GB)"
fi

# 빌드 시작
log_info "ISO 이미지 빌드 시작..."
log_info "이 작업은 10-30분 정도 걸릴 수 있습니다 (첫 빌드)"
echo ""

# 빌드 명령 실행
log_info "빌드 명령 실행 중..."
if nix build .#nixosConfigurations.installer.config.system.build.isoImage; then
    log_success "ISO 빌드 성공!"
    echo ""

    # 결과 확인
    if [ -d "result/iso" ]; then
        ISO_FILE=$(find result/iso -name "*.iso" | head -1)
        if [ -n "$ISO_FILE" ]; then
            ISO_SIZE=$(du -h "$ISO_FILE" | cut -f1)
            log_success "ISO 파일: $ISO_FILE"
            log_success "ISO 크기: $ISO_SIZE"
            echo ""

            # USB 굽기 안내
            echo "======================================"
            echo "  USB에 굽는 방법"
            echo "======================================"
            echo ""
            echo "Linux/macOS:"
            echo "  sudo dd if=$ISO_FILE of=/dev/sdX bs=4M status=progress"
            echo ""
            echo "Windows:"
            echo "  Rufus 또는 balenaEtcher 사용"
            echo "  - Rufus: https://rufus.ie/"
            echo "  - Etcher: https://www.balena.io/etcher/"
            echo ""
            log_warning "⚠️  USB 장치를 올바르게 선택하세요! (데이터 손실 위험)"
        else
            log_error "ISO 파일을 찾을 수 없습니다."
            exit 1
        fi
    else
        log_error "빌드 결과 디렉토리를 찾을 수 없습니다."
        exit 1
    fi
else
    log_error "ISO 빌드 실패"
    echo ""
    echo "문제 해결 방법:"
    echo "1. 디스크 공간 확인: df -h"
    echo "2. Nix 스토어 정리: nix-collect-garbage -d"
    echo "3. BUILD_ISO.md 문서의 트러블슈팅 섹션 참조"
    exit 1
fi

echo ""
log_success "빌드 완료! 🎉"
