{ pkgs, ... }:
{
  # Korean input method
  i18n = {
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          kdePackages.fcitx5-qt
          fcitx5-gtk
          fcitx5-hangul
          fcitx5-mozc
          fcitx5-fluent
        ];
      };
    };
  };
}
