# ISO 이미지 빌드 가이드

이 문서는 커스텀 NixOS 설치 ISO를 빌드하는 방법을 설명합니다.

## 🎯 왜 ISO를 직접 빌드하나요?

- **설정 미리 포함**: 이 저장소의 설정이 이미 포함된 ISO
- **필요한 도구 모두 포함**: 파티션 도구, 한글 입력기 등
- **자동화된 설치**: 설치 과정 간소화
- **오프라인 설치 가능**: 필요한 패키지가 모두 포함됨

## 📋 빌드 요구사항

### 시스템 요구사항
- **OS**: Linux 또는 macOS (NixOS 또는 Nix 패키지 매니저 설치됨)
- **디스크 공간**: 최소 10GB (권장 20GB+)
- **메모리**: 최소 4GB (권장 8GB+)
- **인터넷**: 초기 빌드 시 패키지 다운로드 필요

### 사전 준비

#### NixOS가 아닌 시스템에서 (Linux/macOS)
```bash
# Nix 패키지 매니저 설치
curl -L https://nixos.org/nix/install | sh

# Flakes 활성화
mkdir -p ~/.config/nix
cat > ~/.config/nix/nix.conf << EOF
experimental-features = nix-command flakes
EOF

# 설정 다시 로드
. ~/.nix-profile/etc/profile.d/nix.sh
```

## 🔨 ISO 빌드 방법

### 1단계: 저장소 준비

```bash
# 저장소 클론
git clone https://github.com/YOUR_USERNAME/nix-config.git
cd nix-config

# 또는 이미 클론했다면
cd /path/to/nix-config
```

### 2단계: ISO 빌드

#### 방법 1: Flake를 이용한 빌드 (권장)

```bash
# ISO 이미지 빌드
nix build .#nixosConfigurations.installer.config.system.build.isoImage

# 빌드 시간: 10-30분 (처음 빌드 시, CPU/네트워크 속도에 따라)
# 이후 빌드는 캐시로 인해 훨씬 빠름
```

#### 방법 2: 전통적인 방법

```bash
# ISO 빌드
nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage \
  -I nixos-config=iso/installer.nix
```

### 3단계: 빌드 결과 확인

```bash
# 생성된 ISO 확인
ls -lh result/iso/

# 출력 예시:
# nixos-custom-installer.iso (약 2-3GB)

# ISO 정보 확인
file result/iso/*.iso
```

## 💿 ISO를 USB에 굽기

### Linux에서

```bash
# USB 장치 확인
lsblk

# USB에 ISO 굽기 (⚠️ 주의: USB 내용 모두 삭제됨!)
# sdX를 실제 USB 장치로 변경 (예: sdb, sdc)
sudo dd if=result/iso/nixos-custom-installer.iso \
        of=/dev/sdX \
        bs=4M \
        status=progress \
        conv=fsync

# 또는 더 빠른 방법
sudo cp result/iso/nixos-custom-installer.iso /dev/sdX
sync
```

### macOS에서

```bash
# USB 장치 확인
diskutil list

# USB 언마운트 (diskN을 실제 장치로 변경)
diskutil unmountDisk /dev/diskN

# ISO 굽기
sudo dd if=result/iso/nixos-custom-installer.iso \
        of=/dev/rdiskN \
        bs=4m \
        status=progress

# 완료 후
diskutil eject /dev/diskN
```

### Windows에서

1. **Rufus** 다운로드: https://rufus.ie/
2. Rufus 실행
3. ISO 이미지 선택
4. USB 드라이브 선택
5. "DD 이미지 모드"로 쓰기

또는

1. **balenaEtcher** 다운로드: https://www.balena.io/etcher/
2. ISO 선택 → USB 선택 → Flash

## 🚀 빌드한 ISO로 설치하기

### 1단계: USB로 부팅

1. USB를 컴퓨터에 연결
2. 부팅 메뉴 진입 (보통 F12, F2, Del, Esc 키)
3. USB를 선택하여 부팅

### 2단계: GNOME 데스크톱 부팅 대기

- 자동으로 GNOME 데스크톱으로 부팅됨
- 사용자: `nixos` (자동 로그인)
- 비밀번호: 없음

### 3단계: 설치 가이드 확인

데스크톱에 "Installation Guide" 아이콘이 있습니다:
- 클릭하면 Firefox에서 INSTALL.md가 열림
- 단계별 설치 안내 확인

### 4단계: 설치 진행

```bash
# 터미널 열기 (Ctrl+Alt+T)

# 이미 포함된 설정 확인
ls /etc/nixos-config/

# 네트워크 연결 (WiFi)
nmtui

# 파티션 생성 (GParted 또는 CLI)
gparted  # GUI
# 또는
sudo parted /dev/sdX

# 나머지는 INSTALL.md 가이드 참조
```

## ⚙️ ISO 커스터마이징

### 추가 패키지 포함

`iso/installer.nix` 편집:

```nix
environment.systemPackages = with pkgs; [
  # 기존 패키지들...

  # 추가하고 싶은 패키지
  neovim
  tmux
  # 등등...
];
```

### ISO 크기 줄이기

```nix
# iso/installer.nix에서
imports = [
  # GNOME 대신 최소 설치 ISO 사용
  "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
];
```

### 다른 데스크톱 환경

```nix
# KDE Plasma 사용
imports = [
  "${modulesPath}/installer/cd-dvd/installation-cd-graphical-plasma5.nix"
];
```

## 🔍 트러블슈팅

### 빌드 실패: "out of memory"

```bash
# 빌드 작업 수 제한
nix build .#nixosConfigurations.installer.config.system.build.isoImage \
  --cores 2 \
  --max-jobs 2
```

### 빌드 실패: "disk full"

```bash
# Nix 스토어 정리
nix-collect-garbage -d

# 디스크 공간 확인
df -h
```

### USB 부팅이 안 됨

1. **Secure Boot 비활성화**
   - BIOS/UEFI 설정에서 Secure Boot 끄기

2. **UEFI vs Legacy 모드**
   - UEFI 모드로 부팅 시도

3. **다른 USB 포트**
   - USB 2.0 포트 사용 (호환성 좋음)

### ISO가 너무 큼

```bash
# 압축 레벨 조정 (iso/installer.nix)
isoImage.squashfsCompression = "xz";  # 더 작지만 느림
# 또는
isoImage.squashfsCompression = "lz4"; # 더 빠르지만 큼
```

## 📊 빌드 시간 및 크기

### 예상 빌드 시간

| CPU | 첫 빌드 | 증분 빌드 |
|-----|---------|-----------|
| 4코어 | 20-40분 | 2-5분 |
| 8코어 | 10-20분 | 1-3분 |
| 16코어 | 5-15분 | 1-2분 |

### ISO 크기

| 종류 | 크기 |
|------|------|
| Minimal | 800MB - 1GB |
| GNOME (현재) | 2.5GB - 3.5GB |
| Plasma | 2.5GB - 3.5GB |

## 🔄 ISO 업데이트

설정을 변경한 후 ISO 재빌드:

```bash
# 설정 수정
nano iso/installer.nix

# 이전 빌드 결과 삭제
rm -f result

# 재빌드
nix build .#nixosConfigurations.installer.config.system.build.isoImage

# 변경사항이 적으면 빌드가 빠름 (캐시 사용)
```

## 💡 고급 팁

### 1. 빌드 캐시 활성화

```bash
# cachix 설치 (선택사항)
nix-env -iA cachix -f https://cachix.org/api/v1/install

# NixOS 공식 캐시 사용 (빌드 시간 단축)
cachix use nixos
```

### 2. 크로스 컴파일 (ARM64 ISO)

```bash
# ARM64 ISO 빌드 (AMD64 시스템에서)
nix build .#nixosConfigurations.installer.config.system.build.isoImage \
  --system aarch64-linux
```

### 3. Ventoy로 멀티부팅 USB

```bash
# Ventoy 설치: https://www.ventoy.net/
# ISO를 Ventoy USB에 복사만 하면 됨
cp result/iso/*.iso /path/to/ventoy/
```

### 4. 자동 설치 스크립트

ISO에 자동 설치 스크립트 포함:

```bash
# iso/installer.nix에 추가
environment.etc."install.sh" = {
  text = ''
    #!/usr/bin/env bash
    # 자동 설치 스크립트
    # ...
  '';
  mode = "0755";
};
```

## 📚 참고 자료

- [NixOS ISO 빌드 매뉴얼](https://nixos.org/manual/nixos/stable/#sec-building-image)
- [installation-cd 모듈들](https://github.com/NixOS/nixpkgs/tree/master/nixos/modules/installer/cd-dvd)

## ✅ 체크리스트

ISO 빌드 전:
- [ ] Nix/NixOS 설치됨
- [ ] Flakes 활성화됨
- [ ] 충분한 디스크 공간 (20GB+)
- [ ] 인터넷 연결 안정적

ISO 빌드 후:
- [ ] ISO 파일 생성 확인
- [ ] ISO 크기 확인 (2-3GB)
- [ ] USB에 성공적으로 구움
- [ ] USB 부팅 테스트 완료

---

빌드 완료 후 INSTALL.md를 참조하여 설치를 진행하세요! 🎉
