# macOS nix-darwin + home-manager 구현 계획

## 개요
Linux 기반 NixOS 설정과 별개로 macOS용 nix-darwin + home-manager 환경을 `mackintosh/` 디렉터리에 구축하는 프로젝트입니다.

## Phase 1: 기본 nix-darwin 설정 생성

### 목표
- nix-darwin input 추가 및 기본 darwinConfiguration 설정
- 최소한의 macOS 시스템 설정 구현

### 구현 작업
1. **flake.nix 수정**
   - nix-darwin input 추가
   - darwinConfigurations 섹션 추가

2. **mackintosh/darwin-configuration.nix 생성**
   - Nix 설정 (experimental features, flakes 활성화)
   - 기본 시스템 설정
   - nixpkgs 설정 (allowUnfree)
   - 사용자 계정 설정

3. **기본 디렉터리 구조 생성**
   ```
   mackintosh/
   ├── darwin-configuration.nix
   └── modules/
       └── common.nix
   ```

### 검증 방법
- `nix flake check` - flake 구문 및 inputs 검증
- `nix build .#darwinConfigurations.mackintosh.system --dry-run` - darwin 설정 빌드 테스트

---

## Phase 2: Home-manager 통합

### 목표
- nix-darwin과 home-manager 통합 설정
- 기존 zsh 설정 재사용

### 구현 작업
1. **darwin-configuration.nix에 home-manager 모듈 추가**
   - home-manager darwinModule import
   - 사용자별 home-manager 설정 연결

2. **mackintosh/home-manager.nix 생성**
   - 기존 `users/minjunj.nix`의 home-manager 부분 참조
   - Linux 전용 부분 제외 (fcitx5, kakaotalk, NVIDIA 설정 등)
   - macOS 호환 설정만 포함

3. **zsh 설정 재사용**
   - `../zsh/zsh.nix`의 내용을 macOS에 맞게 조정
   - `../zsh/p10k.zsh` 파일 재사용

### 디렉터리 구조
```
mackintosh/
├── darwin-configuration.nix
├── home-manager.nix
└── modules/
    └── common.nix
```

### 검증 방법
- `nix flake check` - flake 전체 검증
- `nix build .#darwinConfigurations.mackintosh.config.home-manager.users.minjunj.home.activationPackage --dry-run` - home-manager 설정 빌드 테스트

---

## Phase 3: macOS 전용 설정 추가

### 목표
- Homebrew 패키지 매니저 연동
- macOS 전용 애플리케이션 설치
- macOS 시스템 설정 커스터마이징

### 구현 작업
1. **Homebrew 설정 추가**
   - Homebrew cask 애플리케이션 정의
   - brew 패키지 설정
   - Mac App Store 애플리케이션 (mas 사용)

2. **macOS 전용 모듈 생성**
   - `mackintosh/modules/macos-apps.nix` - 애플리케이션 설치 설정
   - `mackintosh/modules/system-settings.nix` - 시스템 설정 커스터마이징

3. **macOS 1Password 설정**
   - SSH agent 설정
   - CLI 도구 설정

### 디렉터리 구조
```
mackintosh/
├── darwin-configuration.nix
├── home-manager.nix
└── modules/
    ├── common.nix
    ├── macos-apps.nix
    └── system-settings.nix
```

### 검증 방법
- `nix flake check` - 전체 설정 검증
- `nix build .#darwinConfigurations.mackintosh.system --dry-run` - Homebrew 포함 시스템 빌드 테스트

---

## Phase 4: 공통 모듈 분리 (향후 통합 준비)

### 목표
- 플랫폼 공통 설정을 `shared/` 디렉터리로 분리
- Linux와 macOS 설정의 유기적 통합 준비

### 구현 작업
1. **shared/ 디렉터리 생성**
   - Git 설정 분리
   - zsh 공통 설정 분리
   - 공통 패키지 설정 분리
   - 사용자 기본 설정 분리

2. **플랫폼별 설정 분리**
   - `nixos/` - Linux 전용 설정
   - `mackintosh/` - macOS 전용 설정
   - `shared/` - 플랫폼 공통 설정

3. **조건부 import 구현**
   - 플랫폼별 조건부 설정 로직 구현

### 검증 방법
- `nix flake check` - 전체 flake 검증
- `nix build .#nixosConfigurations.desktop.config.home-manager.users.minjunj.home.activationPackage --dry-run` - Linux 설정 빌드 테스트
- `nix build .#darwinConfigurations.mackintosh.config.home-manager.users.minjunj.home.activationPackage --dry-run` - macOS 설정 빌드 테스트

---

## 전체 완료 후 디렉터리 구조

```
nix-config/
├── flake.nix                 # 통합 flake 설정
├── shared/                   # 플랫폼 공통 설정
│   ├── git.nix
│   ├── zsh-common.nix
│   ├── packages.nix
│   └── user-config.nix
├── nixos/                    # Linux 전용 설정
│   └── common.nix
├── mackintosh/               # macOS 전용 설정
│   ├── darwin-configuration.nix
│   ├── home-manager.nix
│   └── modules/
│       ├── common.nix
│       ├── macos-apps.nix
│       └── system-settings.nix
├── zsh/                      # zsh 설정 (공통)
│   ├── zsh.nix
│   └── p10k.zsh
├── hosts/                    # Linux 호스트별 설정
└── users/                    # Linux 사용자 설정
```

## 사용법

### 정적 검증 (Linux 환경에서 가능)
```bash
# flake 전체 검증
nix flake check

# darwin system 빌드 테스트
nix build .#darwinConfigurations.mackintosh.system --dry-run

# home-manager 설정 빌드 테스트
nix build .#darwinConfigurations.mackintosh.config.home-manager.users.minjunj.home.activationPackage --dry-run
```

### macOS 환경에서 실제 적용 (macOS에서만 가능)
```bash
# nix-darwin 초기 설치
nix run nix-darwin -- switch --flake .#mackintosh

# 이후 업데이트
darwin-rebuild switch --flake .#mackintosh
```

## 주의사항
- 각 Phase는 순서대로 진행해야 함
- Phase 1 완료 후 다음 Phase 진행
- 각 Phase 완료 후 반드시 정적 검증 단계 수행
- 실제 적용은 macOS 환경에서만 가능
- Linux 환경에서는 `nix flake check`와 `nix build --dry-run`으로 검증