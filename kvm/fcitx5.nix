{ pkgs, ... }:
{
  # Korean input method (fcitx5)
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-hangul # Korean input
      fcitx5-gtk # GTK integration
      kdePackages.fcitx5-qt # Qt6 integration for Plasma
    ];
  };

  # fcitx5 configuration - Right Alt for Korean toggle
  xdg.configFile."fcitx5/config".text = ''
    [Hotkey/TriggerKeys]
    0=Alt_R
  '';

  xdg.configFile."fcitx5/profile".text = ''
    [Groups/0]
    Name=Default
    Default Layout=us
    DefaultIM=hangul

    [Groups/0/Items/0]
    Name=keyboard-us
    Layout=

    [Groups/0/Items/1]
    Name=hangul
    Layout=

    [GroupOrder]
    0=Default
  '';
}
