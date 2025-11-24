{ pkgs, ... }:
{
  # Korean input method
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enable = true;
      type = "kime";
      kime.iconColor = "White";
    };
  }
}
