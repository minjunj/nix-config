{pkgs, ...}: let
  apple-theme-src = pkgs.fetchFromGitHub {
    owner = "zayronxio";
    repo = "Apple-theme-Plasma";
    rev = "93ed9d35c13d1711e887e6cb4f222063496c28ab";
    hash = "";  # First run will show the correct hash
  };
in {
  # Install plasma desktop themes directly to ~/.local/share
  home.file = {
    ".local/share/plasma/desktoptheme/Apple-BigSur-LLT".source = "${apple-theme-src}/Apple-BigSur-LLT";
    ".local/share/plasma/desktoptheme/AppleDark-ALL".source = "${apple-theme-src}/AppleDark-ALL";
    ".local/share/plasma/desktoptheme/AppleDark-ALL-AccentDinamic".source = "${apple-theme-src}/AppleDark-ALL-AccentDinamic";
    ".local/share/plasma/desktoptheme/Apple-Ventura".source = "${apple-theme-src}/Apple-Ventura";

    ".local/share/plasma/look-and-feel/Apple-Ventura-Dark".source = "${apple-theme-src}/look-and-feel/Apple-Ventura-Dark";
  };
}
