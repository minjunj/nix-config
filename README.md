# NixOS 멀티 플랫폼 설정

AMD64(x86_64)와 ARM64(Apple Silicon) 환경에서 작동하는 NixOS 설정입니다.

## 주요 기능

### 🖥️ 멀티 플랫폼 지원
- **AMD64 (ultrathink)**: Intel/AMD CPU 시스템
- **ARM64 (asahi)**: Apple Silicon Mac (Asahi Linux)

### 🎨 데스크톱 환경
- **GNOME**: 안정적이고 사용하기 쉬운 데스크톱
- **macOS 스타일 테마**: WhiteSur 테마 + Dash to Dock
- **한글 입력**: fcitx5 + 한글 입력기

### 🐚 개발 환경
- **zsh + oh-my-zsh**: 강력한 쉘 환경
- **asdf**: 버전 관리 (terraform, node, python 등)
- **VSCode**: 확장 프로그램 포함
- **Docker**: NVIDIA GPU 지원 포함

### 🎮 NVIDIA GPU 지원
- NVIDIA 드라이버 자동 설정
- Docker NVIDIA 런타임
- CUDA 개발 도구

### 📁 작업 공간
- `~/workspace`: 프로젝트 작업 공간
- `~/workspace/scratch`: 임시 작업 폴더 (Git 무시)

## 시스템 요구사항

### 최소 사양
- **디스크**: 20GB 이상 (권장 50GB+)
- **메모리**: 4GB 이상 (권장 8GB+)
- **부팅**: UEFI 지원 필수

### 지원 플랫폼
- Intel/AMD 64비트 CPU (x86_64)
- Apple Silicon (M1/M2/M3 - ARM64, Asahi Linux 필요)

## 설치 방법

### 빠른 시작

1. **[BUILD_ISO.md](./BUILD_ISO.md)** - 커스텀 ISO 빌드 (권장)
2. **[INSTALL.md](./INSTALL.md)** - 단계별 설치 가이드

### 1. NixOS 설치 미디어 준비

#### 옵션 A: 커스텀 ISO 빌드 (권장) ⭐

이 저장소의 설정이 이미 포함된 ISO를 빌드할 수 있습니다:

```bash
# 저장소 클론
git clone https://github.com/YOUR_USERNAME/nix-config.git
cd nix-config

# ISO 빌드 (자세한 방법은 BUILD_ISO.md 참조)
nix build .#nixosConfigurations.installer.config.system.build.isoImage

# USB에 굽기
sudo dd if=result/iso/nixos-custom-installer.iso of=/dev/sdX bs=4M status=progress
```

**장점:**
- 이 설정이 이미 `/etc/nixos-config`에 포함됨
- 필요한 모든 도구 포함 (GParted, 한글 입력기 등)
- 설치 가이드가 데스크톱에 바로가기로 제공

#### 옵션 B: 공식 ISO 사용

```bash
# NixOS ISO 다운로드
# https://nixos.org/download.html

# USB에 굽기 (Linux/macOS)
sudo dd if=nixos-minimal-xx.xx.iso of=/dev/sdX bs=4M status=progress
```

#### ARM64 시스템 (Asahi Linux)
```bash
# Asahi Linux 설치 스크립트 실행 (macOS에서)
curl https://alx.sh | sh

# NixOS를 선택하여 설치
```

### 2. 시스템 파티셔닝

```bash
# 디스크 확인
lsblk

# 파티션 생성 (예시: /dev/nvme0n1)
sudo parted /dev/nvme0n1 -- mklabel gpt

# EFI 파티션 (512MB)
sudo parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB
sudo parted /dev/nvme0n1 -- set 1 esp on

# 루트 파티션 (나머지 전체)
sudo parted /dev/nvme0n1 -- mkpart primary 512MiB 100%

# 파일시스템 생성
sudo mkfs.fat -F 32 -n boot /dev/nvme0n1p1
sudo mkfs.ext4 -L nixos /dev/nvme0n1p2

# 마운트
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
```

### 3. 하드웨어 설정 생성

```bash
# 하드웨어 설정 자동 생성
sudo nixos-generate-config --root /mnt

# 생성된 파일 확인
ls /mnt/etc/nixos/
# configuration.nix
# hardware-configuration.nix
```

### 4. 이 저장소 설정 복사

```bash
# Git 설치 (설치 환경에서)
nix-shell -p git

# 이 저장소 클론
cd /mnt/etc/nixos/
git clone https://github.com/YOUR_USERNAME/nix-config.git
# 또는 USB로 복사

# 기존 설정 백업
mv configuration.nix configuration.nix.backup

# 하드웨어 설정 복사
# AMD64 (ultrathink)
cp hardware-configuration.nix nix-config/hosts/ultrathink/

# ARM64 (asahi)
cp hardware-configuration.nix nix-config/hosts/asahi/
```

### 5. 설정 커스터마이징

#### 호스트명 선택
- AMD64: `ultrathink`
- ARM64: `asahi`
- 다른 이름 원하면 `flake.nix`의 `nixosConfigurations` 수정

#### Git 설정 수정
```bash
# home.nix 편집
nano nix-config/home.nix

# Git 사용자 정보 변경 (46-47번째 줄 근처)
programs.git = {
  userName = "본인 이름";
  userEmail = "본인@이메일.com";
};
```

#### NVIDIA GPU 설정 (선택)
GPU가 **없는** 경우:
```bash
# hosts/ultrathink/configuration.nix 편집
nano nix-config/hosts/ultrathink/configuration.nix

# 15번째 줄을 주석 처리
# ../../modules/nvidia.nix
```

GPU가 **있는** 경우: 그대로 두면 됩니다.

#### AMD CPU 사용 시
```bash
# hosts/ultrathink/configuration.nix 편집
nano nix-config/hosts/ultrathink/configuration.nix

# 29번째 줄 수정
kernelModules = [ "kvm-amd" ];  # kvm-intel 대신
```

### 6. NixOS 설치

```bash
cd /mnt/etc/nixos/nix-config

# Flake를 이용한 설치
# AMD64 (ultrathink)
sudo nixos-install --flake .#ultrathink

# ARM64 (asahi)
sudo nixos-install --flake .#asahi

# 루트 비밀번호 설정 (프롬프트에서)
# 사용자 비밀번호도 설정
sudo nixos-enter --root /mnt
passwd user
exit

# 재부팅
reboot
```

## 설치 후 설정

### 1. 시스템 업데이트
```bash
# Flake inputs 업데이트
cd ~/.config/nix-config  # 또는 설정 파일 위치
nix flake update

# 시스템 재빌드
sudo nixos-rebuild switch --flake .#ultrathink
# 또는
sudo nixos-rebuild switch --flake .#asahi
```

### 2. GNOME 테마 적용

**GNOME Tweaks 실행:**
```bash
gnome-tweaks
```

**테마 설정:**
- Appearance → Applications: `WhiteSur-Light` 또는 `WhiteSur-Dark`
- Appearance → Icons: `WhiteSur`
- Appearance → Cursor: `Bibata-Modern-Classic`
- Appearance → Shell: `WhiteSur-Light` 또는 `WhiteSur-Dark`

**Dash to Dock 설정:**
1. Extensions에서 `Dash to Dock` 찾기
2. 설정:
   - Position: `Bottom` (하단)
   - Icon size: 48-64px
   - Intelligent autohide: ON

### 3. asdf 플러그인 설치

```bash
# Terraform
asdf plugin add terraform
asdf install terraform latest
asdf global terraform latest

# Node.js
asdf plugin add nodejs
asdf install nodejs latest
asdf global nodejs latest

# Python
asdf plugin add python
asdf install python latest
asdf global python latest

# 설치된 것 확인
asdf plugin list
asdf list
```

### 4. VSCode 확장 추가

VSCode는 이미 설치되어 있지만, 추가 확장을 원한다면:

```bash
# home.nix 편집
nano ~/.config/nix-config/home.nix

# extensions 리스트에 추가 (97번째 줄 근처)
programs.vscode.extensions = with pkgs.vscode-extensions; [
  # 여기에 원하는 확장 추가
];

# 재빌드
home-manager switch
```

### 5. Docker 테스트

```bash
# Docker 서비스 시작 (자동 시작됨)
sudo systemctl status docker

# 테스트
docker run hello-world

# NVIDIA GPU 테스트 (GPU 있는 경우)
docker run --rm --gpus all nvidia/cuda:12.0-base nvidia-smi
```

## 일상적인 사용

### 시스템 업데이트
```bash
cd /etc/nixos/nix-config  # 설정 파일 위치
nix flake update
sudo nixos-rebuild switch --flake .#ultrathink
```

### 패키지 추가
```bash
# 시스템 전체 패키지
nano /etc/nixos/nix-config/modules/base.nix
# environment.systemPackages에 추가

# 사용자 패키지
nano ~/.config/nix-config/home.nix
# home.packages에 추가

# 적용
sudo nixos-rebuild switch --flake .#ultrathink
```

### 설정 롤백
```bash
# 이전 설정으로 되돌리기
sudo nixos-rebuild switch --rollback

# 또는 부팅 시 GRUB에서 이전 세대 선택
```

### 가비지 컬렉션
```bash
# 30일 이상 된 패키지 삭제 (자동으로 주간 실행됨)
sudo nix-collect-garbage --delete-older-than 30d

# 현재 세대만 남기고 모두 삭제 (주의!)
sudo nix-collect-garbage -d
```

## 트러블슈팅

### NVIDIA 드라이버 문제
```bash
# GPU 인식 확인
lspci | grep -E "VGA|3D"

# NVIDIA 드라이버 로드 확인
lsmod | grep nvidia

# nvidia-smi 테스트
nvidia-smi
```

### 부팅 안 됨
1. GRUB에서 이전 세대 선택
2. 부팅 후 문제 수정
3. 재빌드

### oh-my-zsh 플러그인 안 됨
```bash
# home.nix 확인
cat ~/.config/nix-config/home.nix | grep plugins

# zsh 재시작
exec zsh
```

### Home Manager 오류
```bash
# Home Manager 수동 업데이트
nix flake update
home-manager switch --flake .#user
```

## 파일 구조

```
nix-config/
├── flake.nix                 # 메인 Flake 설정 (플랫폼 정의)
├── home.nix                  # Home Manager (사용자 설정)
├── modules/
│   ├── base.nix              # 공통 시스템 설정
│   ├── nvidia.nix            # NVIDIA GPU 설정
│   └── gnome-macos-theme.nix # GNOME 테마 설정
└── hosts/
    ├── ultrathink/           # AMD64 호스트
    │   ├── configuration.nix
    │   └── hardware-configuration.nix
    └── asahi/                # ARM64 호스트
        ├── configuration.nix
        └── hardware-configuration.nix
```

## 유용한 명령어

```bash
# 현재 세대 목록 보기
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# 특정 세대로 전환
sudo nix-env --switch-generation 42 --profile /nix/var/nix/profiles/system
sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch

# 스토어 최적화 (하드링크)
sudo nix-store --optimise

# 설정 문법 검사
nix flake check

# 빌드만 하고 설치 안 함
sudo nixos-rebuild build --flake .#ultrathink
```

## 추가 참고 자료

- [NixOS 공식 문서](https://nixos.org/manual/nixos/stable/)
- [Home Manager 매뉴얼](https://nix-community.github.io/home-manager/)
- [Asahi Linux](https://asahilinux.org/)
- [WhiteSur 테마](https://github.com/vinceliuice/WhiteSur-gtk-theme)

## 라이선스

MIT License
