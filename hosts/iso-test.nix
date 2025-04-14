{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  networking.hostName = "nixos-test";
  time.timeZone = "Asia/Seoul";

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    password = "1234";
    shell = pkgs.zsh;  # 기본 쉘을 zsh로 설정
  };

  services.sshd.enable = true;

  # zsh를 설치
  environment.systemPackages = with pkgs; [
    zsh
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    # oh-my-zsh 설정
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" ];
      theme = "";
    };

    # powerlevel10k 설정
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.fetchFromGitHub {
          owner = "romkatv";
          repo = "powerlevel10k";
          rev = "v1.19.0";
          sha256 = "sha256-+hzjSbbrXr0w1rGHm6m2oZ6pfmD6UUDBfPd7uMg5l5c=";
        };
        file = "powerlevel10k.zsh-theme";
      }
    ];
  };

  system.stateVersion = "24.11";
}
