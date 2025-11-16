{
  programs.zsh.shellAliases = {
    # Git aliases
    g-s = "git status";
    g-a = "git add . && git status";
    g-c = "git commit";
    g-p = "git push";
    g-l = "git pull origin";
    g-d = "git diff";

    # NixOS specific
    rebuild = "sudo nixos-rebuild switch --flake .";
    update = "nix flake update";
  };
}
