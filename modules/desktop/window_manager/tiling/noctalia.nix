{ pkgs, inputs, ... }:
{
  home-manager.users.minjunj = {
    # import the home manager module
    imports = [
      inputs.noctalia.homeModules.default
    ];

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
