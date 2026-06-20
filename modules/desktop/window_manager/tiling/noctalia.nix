{ pkgs, inputs, ... }:
{
  home-manager.users.minjunj = {
    # import the home manager module
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        image = "${../../../../assets/gup2.jpg}";
        effect-blur = "7x5";
        scaling = "fill";
        color = "1e1e2e";

        indicator = true;
        clock = true;
        show-failed-attempts = true;

        font = "Noto Sans CJK KR";
        font-size = 24;

        indicator-radius = 72;
        indicator-thickness = 4;

        inside-color = "00000044";
        ring-color = "ffffff66";
        line-color = "00000000";
        text-color = "f5f5f5";
        key-hl-color = "f9e2af";
        separator-color = "00000000";

        inside-clear-color = "fab38733";
        ring-clear-color = "fab387aa";
        text-clear-color = "f5f5f5";

        inside-ver-color = "a6e3a133";
        ring-ver-color = "a6e3a1aa";
        text-ver-color = "f5f5f5";

        inside-wrong-color = "f38ba833";
        ring-wrong-color = "f38ba8aa";
        text-wrong-color = "f5f5f5";
      };
    };

    # configure options
    programs.noctalia-shell = {
      enable = true;
      settings = {
        # configure noctalia here
        bar = {
          density = "compact";
          position = "top";
          showCapsule = false;
          widgets = {
            left = [
              {
                id = "Launcher";
              }
              {
                id = "ActiveWindow";
              }
            ];
            center = [
              {
                hideUnoccupied = false;
                id = "Workspace";
                labelMode = "none";
              }
            ];
            right = [
              {
                id = "Network";
              }
              {
                id = "Bluetooth";
              }
              {
                id = "SystemMonitor";
              }
              {
                id = "Battery";
              }
              {
                formatHorizontal = "HH:mm";
                formatVertical = "HH mm";
                id = "Clock";
                useMonospacedFont = true;
                usePrimaryColor = true;
              }
              {
                id = "ControlCenter";
                useDistroLogo = true;
              }
            ];
          };
        };
        controlCenter = {
          shortcuts = {
            left = [
              {
                id = "Network";
              }
              {
                id = "Bluetooth";
              }
              {
                id = "NoctaliaPerformance";
              }
            ];
            right = [
              {
                id = "Notifications";
              }
              {
                id = "PowerProfile";
              }
              {
                id = "KeepAwake";
              }
              {
                id = "NightLight";
              }
            ];
            cards = [
            {
              enabled = false;
              id = "profile-card";
            }
            {
              enabled = false;
              id = "shortcuts-card";
            }
            {
              enabled = true;
              id = "audio-card";
            }
            {
              enabled = false;
              id = "brightness-card";
            }
            {
              enabled = true;
              id = "weather-card";
            }
            {
              enabled = false;
              id = "media-sysmon-card";
            }
          ];
          };
        };
        audio = {
          volumeStep = 1;
          volumeFeedback = true;
        };
        sessionMenu.countdownDuration = 1000; # 1s
        colorSchemes = {
          useWallpaperColors = true;
          predefinedScheme = "Catppuccin";
        };
        general = {
          # avatarImage = "/home/drfoobar/.face";
          radiusRatio = 0.2;
        };
        location = {
          monthBeforeDay = true;
          name = "Seoul, Korea";
        };
      };
      # this may also be a string or a path to a JSON file.
    };
  };
}
