{pkgs, ...}: let
  apple-ventura-dark = pkgs.stdenv.mkDerivation {
    pname = "apple-ventura-dark";
    version = "1.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "zayronxio";
      repo = "Apple-theme-Plasma";
      rev = "main";
      hash = "";  # First run will show the correct hash
    };

    installPhase = ''
      mkdir -p $out/share/plasma/look-and-feel
      cp -r look-and-feel/Apple-Ventura-Dark $out/share/plasma/look-and-feel/
    '';

    meta = {
      description = "Apple Ventura Dark look and feel for KDE Plasma";
      homepage = "https://github.com/zayronxio/Apple-theme-Plasma";
    };
  };
in {
  home.packages = [apple-ventura-dark];
}
