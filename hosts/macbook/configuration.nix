{
  inputs,
  pkgs,
  ...
}: let
  niriPackage = inputs.niri-flake.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
in {
  imports = [
    ../../modules/nixos/common.nix
    ./hardware-configuration.nix
    inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
    inputs.home-manager.nixosModules.home-manager
    inputs.niri-flake.nixosModules.niri
    ../../modules/users/minjunj-macbook.nix
    ../../modules/desktop/window_manager/tiling/noctalia.nix
    ./asahi.nix
    ./other.nix
  ];

  networking.hostName = "macbook";
  networking.networkmanager.enable = true;

  environment.pathsToLink = ["/share/applications" "/share/xdg-desktop-portal"];
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  programs.niri = {
    enable = true;
    package = niriPackage;
  };

  services.displayManager.sddm.enable = false;
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd ${niriPackage}/bin/niri-session";
      user = "greeter";
    };
  };

  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      naturalScrolling = true;
      disableWhileTyping = true;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config.common.default = "*";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
  };
}
