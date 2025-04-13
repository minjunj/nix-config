{
  description = "Ubuntu 24.04 Nix 설정";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      lib = nixpkgs.lib;
    in {
      homeConfigurations.ubuntu = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
        ];
      };
      
      apps.${system}.default = {
        type = "app";
        program = toString (pkgs.writeShellScriptBin "apply-config" ''
          #!${pkgs.bash}/bin/bash
          echo "Nix 설정을 적용합니다..."
          ${home-manager.packages.${system}.default}/bin/home-manager switch --flake ${self}#ubuntu
          # 종료 코드 확인 및 메시지 출력
          if [ $? -eq 0 ]; then
            echo ""
            echo "==============================================="
            echo "🎉 설정이 성공적으로 완료되었습니다! 🎉"
            echo "==============================================="
            echo "zsh를 기본 셸로 설정하려면 다음 명령어를 실행하세요:"
            echo "chsh -s \$(which zsh)"
            echo ""
            echo "새로운 셸을 사용하려면 터미널을 재시작하거나 로그아웃 후 다시 로그인하세요."
          else
            echo ""
            echo "⚠️ 설정 적용 중 오류가 발생했습니다. 위의 메시지를 확인하세요."
          fi
        ''
        + "/bin/apply-config");
      };
    };
}
