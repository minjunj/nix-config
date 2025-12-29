1. nix-darwin 설치

# nix-darwin 설치
nix run nix-darwin -- switch --flake /path/to/your/nix-config#mackintosh

2. 최초 적용 후 일반 사용

# 설정 변경 후 재빌드/적용
darwin-rebuild switch --flake /path/to/your/nix-config#mackintosh

# 또는 alias가 설정되면 (common.nix:32에 정의됨)
darwin-rebuild .#mackintosh

3. 유용한 옵션들

# 빌드만 하고 적용하지 않음 (테스트용)
darwin-rebuild build --flake .#mackintosh

# 이전 설정으로 롤백
darwin-rebuild --rollback

# 현재 generation 확인
darwin-rebuild --list-generations

4. 트러블슈팅

# 상세 로그로 디버깅
darwin-rebuild switch --flake .#mackintosh --show-trace

# 강제 재빌드 (캐시 무시)
darwin-rebuild switch --flake .#mackintosh --rebuild
