# 빠른 설치 가이드

NixOS를 처음 설치하는 분들을 위한 간단한 가이드입니다.

## 📋 설치 전 체크리스트

- [ ] NixOS 설치 미디어 준비됨 (USB 또는 ISO)
- [ ] 백업 완료 (중요한 데이터!)
- [ ] 인터넷 연결 확인
- [ ] UEFI 부팅 모드 확인 (BIOS에서 설정)

## 🚀 빠른 설치 (AMD64)

### 1단계: 설치 미디어 부팅

USB로 부팅한 후 터미널에서:

```bash
# 인터넷 연결 확인
ping -c 3 google.com

# WiFi 연결 필요시
sudo systemctl start wpa_supplicant
wpa_cli
> add_network
> set_network 0 ssid "WiFi이름"
> set_network 0 psk "비밀번호"
> enable_network 0
> quit
```

### 2단계: 디스크 파티션

```bash
# 디스크 확인 (예: nvme0n1, sda 등)
lsblk

# 파티션 생성 스크립트 (디스크 경로 수정 필요!)
export DISK=/dev/nvme0n1  # ⚠️ 본인 디스크로 변경!

# GPT 파티션 테이블 생성
sudo parted $DISK -- mklabel gpt

# EFI 파티션 (512MB)
sudo parted $DISK -- mkpart ESP fat32 1MiB 512MiB
sudo parted $DISK -- set 1 esp on

# 루트 파티션 (나머지)
sudo parted $DISK -- mkpart primary 512MiB 100%

# 파일시스템 생성
sudo mkfs.fat -F 32 -n boot ${DISK}p1    # NVMe: p1, SATA: 1
sudo mkfs.ext4 -L nixos ${DISK}p2        # NVMe: p2, SATA: 2

# 마운트
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
```

### 3단계: 하드웨어 설정 생성

```bash
# 하드웨어 설정 자동 생성
sudo nixos-generate-config --root /mnt
```

### 4단계: 이 설정 복사

```bash
# Git 설치
nix-shell -p git

# 설정 클론
cd /mnt/etc/nixos/
sudo git clone https://github.com/YOUR_USERNAME/nix-config.git

# 하드웨어 설정 복사
sudo cp hardware-configuration.nix nix-config/hosts/ultrathink/

# 설정 확인
ls -la nix-config/hosts/ultrathink/
```

### 5단계: 설정 수정

#### 필수: Git 정보 수정
```bash
sudo nano nix-config/home.nix

# 46-47번째 줄 수정:
# userName = "본인 이름";
# userEmail = "본인@이메일.com";
```

#### NVIDIA GPU 없으면:
```bash
sudo nano nix-config/hosts/ultrathink/configuration.nix

# 15번째 줄 주석 처리:
# ../../modules/nvidia.nix
```

#### AMD CPU 사용 시:
```bash
sudo nano nix-config/hosts/ultrathink/configuration.nix

# 29번째 줄 수정:
kernelModules = [ "kvm-amd" ];
```

### 6단계: 설치!

```bash
cd /mnt/etc/nixos/nix-config

# 설치 실행
sudo nixos-install --flake .#ultrathink

# 비밀번호 설정
# (프롬프트가 나오면)
# 루트 비밀번호: 설치 완료 후 나옴
# 사용자 비밀번호: 직접 설정 필요

# 사용자 비밀번호 설정
sudo nixos-enter --root /mnt
passwd user
exit

# 재부팅
reboot
```

## 🍎 Apple Silicon (Asahi Linux) 설치

### 1단계: Asahi Linux 설치

macOS에서:
```bash
curl https://alx.sh | sh
```

설치 중 **NixOS** 옵션 선택

### 2단계: NixOS로 부팅 후

```bash
# 이 설정 클론
sudo mkdir -p /etc/nixos
cd /etc/nixos
sudo git clone https://github.com/YOUR_USERNAME/nix-config.git

# 하드웨어 설정 생성 및 복사
sudo nixos-generate-config
sudo cp /etc/nixos/hardware-configuration.nix nix-config/hosts/asahi/

# Git 정보 수정 (위와 동일)
sudo nano nix-config/home.nix

# 설치
cd nix-config
sudo nixos-rebuild switch --flake .#asahi
```

## ✅ 설치 후 확인

재부팅 후:

```bash
# 1. 버전 확인
nixos-version

# 2. GNOME 실행 확인
echo $XDG_CURRENT_DESKTOP
# 출력: GNOME

# 3. Docker 확인
docker run hello-world

# 4. GPU 확인 (NVIDIA 있는 경우)
nvidia-smi

# 5. zsh 확인
echo $SHELL
# 출력: /run/current-system/sw/bin/zsh
```

## 🎨 테마 적용

1. **GNOME Tweaks 실행**
   ```bash
   gnome-tweaks
   ```

2. **Appearance 탭에서:**
   - Applications: `WhiteSur-Light`
   - Icons: `WhiteSur`
   - Cursor: `Bibata-Modern-Classic`

3. **Extensions 탭에서:**
   - `Dash to Dock` 활성화 및 설정
   - Position: Bottom
   - Icon size: 48px

## 🔧 문제 해결

### 부팅이 안 돼요
- GRUB에서 이전 세대 선택 (Advanced Options)
- 부팅 후 설정 수정

### 네트워크가 안 돼요
```bash
# NetworkManager 시작
sudo systemctl start NetworkManager

# WiFi 연결
nmtui
```

### NVIDIA 드라이버 문제
```bash
# GPU 인식 확인
lspci | grep -i nvidia

# 드라이버 확인
nvidia-smi

# 실패 시 설정 확인
sudo nano /etc/nixos/nix-config/hosts/ultrathink/configuration.nix
```

### 한글 입력이 안 돼요
```bash
# fcitx5 시작
fcitx5 &

# 또는 재로그인
# GNOME 설정 > 지역 및 언어 > 입력 소스에서 한글 추가
```

## 📚 다음 단계

1. **asdf 플러그인 설치**
   ```bash
   asdf plugin add terraform
   asdf install terraform latest
   ```

2. **VSCode 설정**
   - VSCode 실행
   - 확장 자동 설치 확인

3. **Chrome 설정**
   - 로그인 및 동기화

4. **workspace 사용**
   ```bash
   cd ~/workspace
   # 여기서 프로젝트 작업
   ```

## 🆘 도움이 필요하면

- [README.md](./README.md) - 자세한 설명
- [NixOS 매뉴얼](https://nixos.org/manual/nixos/stable/)
- [NixOS Discourse](https://discourse.nixos.org/)

---

설치 완료! 🎉
