# macOS system settings and preferences
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # macOS system preferences
  system.defaults = {
    # Dock preferences
    dock = {
      autohide = true;
      orientation = "bottom";
      show-recents = false;
      tilesize = 48;
      minimize-to-application = true;
    };

    # Finder preferences
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXEnableExtensionChangeWarning = false;
      FXDefaultSearchScope = "SCcf"; # Search current folder
    };

    # Trackpad preferences
    trackpad = {
      Clicking = true; # Enable tap to click
      TrackpadThreeFingerDrag = true;
    };

    # Keyboard preferences
    NSGlobalDomain = {
      AppleKeyboardUIMode = 3; # Full keyboard access
      ApplePressAndHoldEnabled = false; # Disable press and hold
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      
      # Interface preferences
      AppleInterfaceStyle = "Dark"; # Dark mode
      AppleShowScrollBars = "WhenScrolling";
      
      # Save preferences
      NSDocumentSaveNewDocumentsToCloud = false;
    };


    # Screenshots
    screencapture = {
      location = "~/Desktop/Screenshots";
      type = "png";
    };

    # Login window
    loginwindow = {
      GuestEnabled = false;
    };
  };


  # Font configuration
  fonts = {
    packages = with pkgs; [
      # Nerd Fonts
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.hack
    ];
  };

  # Time zone
  time.timeZone = "Asia/Seoul";
}