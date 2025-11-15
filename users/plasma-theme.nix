{pkgs, ...}: let
  apple-ventura-dark = pkgs.stdenv.mkDerivation {
    pname = "apple-ventura-dark";
    version = "1.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "zayronxio";
      repo = "Apple-theme-Plasma";
      rev = "93ed9d35c13d1711e887e6cb4f222063496c28ab";
      hash = "";  # First run will show the correct hash
    };

    installPhase = ''
      runHook preInstall

      # Install plasma desktop themes
      mkdir -p $out/share/plasma/desktoptheme
      for theme in Apple-BigSur-LLT AppleDark-ALL AppleDark-ALL-AccentDinamic Apple-Ventura; do
        cp -r "$theme" $out/share/plasma/desktoptheme/
      done

      # Install look-and-feel
      mkdir -p $out/share/plasma/look-and-feel
      cp -r look-and-feel/* $out/share/plasma/look-and-feel/

      runHook postInstall
    '';

    meta = {
      description = "Apple Ventura Dark look and feel for KDE Plasma";
      homepage = "https://github.com/zayronxio/Apple-theme-Plasma";
    };
  };
in {
  home.packages = [apple-ventura-dark];
}
