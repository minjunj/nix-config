{
  description = "NixOS configuration with multi-platform support";

  # inputs: 외부에서 가져올 패키지나 모듈들을 정의
  # 다른 프로젝트의 코드를 가져와서 사용하는 것과 비슷함
  inputs = {
    # nixpkgs: NixOS의 메인 패키지 저장소
    # nixos-unstable: 최신 패키지를 사용 (stable보다 새로운 버전)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # home-manager: 사용자별 설정 관리 도구
    # dotfiles, 프로그램 설정 등을 선언적으로 관리할 수 있음
    home-manager = {
      url = "github:nix-community/home-manager";
      # nixpkgs를 메인과 동일하게 사용 (버전 충돌 방지)
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixos-apple-silicon: Apple M1/M2/M3 칩(ARM64)용 NixOS 지원
    # Asahi Linux에서 필요한 드라이버와 설정을 제공
    nixos-apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # outputs: 이 flake가 제공하는 결과물들
  # self: 현재 flake 자신을 참조
  # @inputs: 위에서 정의한 모든 inputs를 한번에 받기
  outputs = { self, nixpkgs, home-manager, nixos-apple-silicon, ... }@inputs:
    let
      # mkSystem: 시스템 설정을 만드는 헬퍼 함수
      # 중복 코드를 줄이고 여러 호스트를 쉽게 관리하기 위함
      mkSystem = { hostname, system, isAsahi ? false }: nixpkgs.lib.nixosSystem {
        inherit system;  # x86_64-linux 또는 aarch64-linux

        # specialArgs: 모든 모듈에서 사용할 수 있는 추가 인자들
        specialArgs = { inherit inputs hostname isAsahi; };

        # modules: 시스템 구성에 포함할 모듈들의 리스트
        modules = [
          # 호스트별 메인 설정 파일 (하드웨어 설정 등)
          ./hosts/${hostname}/configuration.nix

          # 모든 시스템에 공통으로 적용되는 기본 설정
          ./modules/base.nix

          # Asahi Linux인 경우에만 Apple Silicon 지원 모듈 추가
          # 일반 AMD64 시스템에서는 빈 모듈({})을 추가
          (if isAsahi then nixos-apple-silicon.nixosModules.apple-silicon-support else {})

          # Home Manager를 NixOS 모듈로 통합
          home-manager.nixosModules.home-manager
          {
            # 시스템의 nixpkgs를 home-manager에서도 사용
            home-manager.useGlobalPkgs = true;
            # 패키지를 사용자별로 설치
            home-manager.useUserPackages = true;
            # "user"라는 사용자의 home-manager 설정 파일 지정
            home-manager.users.user = import ./home.nix;
            # home-manager 모듈에도 specialArgs 전달
            home-manager.extraSpecialArgs = { inherit inputs hostname; };
          }
        ];
      };
    in
    {
      # nixosConfigurations: 실제 시스템 설정들
      # nixos-rebuild switch --flake .#ultrathink 처럼 사용

      # AMD64 시스템 (ultrathink 호스트)
      nixosConfigurations.ultrathink = mkSystem {
        hostname = "ultrathink";
        system = "x86_64-linux";  # Intel/AMD 64비트
        isAsahi = false;
      };

      # ARM64 시스템 (Asahi Linux - Apple Silicon Mac)
      nixosConfigurations.asahi = mkSystem {
        hostname = "asahi";
        system = "aarch64-linux";  # ARM 64비트
        isAsahi = true;
      };

      # 설치용 ISO 이미지 (AMD64)
      # =========================
      # nix build .#installer-iso 명령으로 ISO 생성
      nixosConfigurations.installer = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./iso/installer.nix
        ];
      };
    };
}
