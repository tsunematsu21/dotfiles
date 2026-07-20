_:

{
  flake.modules.darwin.defaults = {
    system.defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        AppleShowScrollBars = "Always";
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        ApplePressAndHoldEnabled = false;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSWindowShouldDragOnGesture = true;
        "com.apple.keyboard.fnState" = true;
        "com.apple.trackpad.scaling" = 3.0;
      };

      ".GlobalPreferences" = {
        "com.apple.mouse.scaling" = 3.0;
      };

      hitoolbox.AppleFnUsageType = "Change Input Source";

      loginwindow = {
        GuestEnabled = false;
      };

      menuExtraClock = {
        Show24Hour = true;
        ShowDate = 1;
        ShowSeconds = false;
      };

      trackpad = {
        Clicking = true;
        FirstClickThreshold = 0;
        TrackpadThreeFingerDrag = false;
      };

      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        FXDefaultSearchScope = "SCcf"; # Current folder
        FXPreferredViewStyle = "Nlsv"; # List view
        FXRemoveOldTrashItems = true;
        FXEnableExtensionChangeWarning = false;
        ShowPathbar = true;
        ShowStatusBar = true;
        QuitMenuItem = true;
        _FXShowPosixPathInTitle = true;
      };

      dock = {
        autohide = true;
        autohide-delay = 0.25;
        autohide-time-modifier = 0.5;
        expose-animation-duration = 0.1;
        launchanim = false;
        mineffect = "suck";
        minimize-to-application = true;
        mru-spaces = false;
        orientation = "bottom";
        persistent-apps = [
          "/System/Applications/System Settings.app"
          "/System/Applications/App Store.app"
          "/System/Applications/Notes.app"
          "/Applications/Obsidian.app"
          "/System/Applications/Photos.app"
          "/System/Cryptexes/App/System/Applications/Safari.app"
          "/System/Applications/Mail.app"
          "/System/Applications/Music.app"
          "/Applications/Visual Studio Code.app"
          "/Applications/ChatGPT.app"
          "/Applications/Ghostty.app"
        ];
        scroll-to-open = true;
        show-recents = false;
        tilesize = 48;
        # Hot corner
        wvous-tl-corner = 2; # Mission Control
        wvous-tr-corner = 12; # Notification Center
        wvous-bl-corner = 3; # Application Windows
        wvous-br-corner = 13; # Lock Screen
      };

      screencapture = {
        disable-shadow = true;
        include-date = true;
        location = "~/Pictures";
        show-thumbnail = false;
        type = "png";
      };

      screensaver = {
        askForPassword = true;
        askForPasswordDelay = 0;
      };

      WindowManager = {
        EnableStandardClickToShowDesktop = false;
      };
    };

    system.defaults.CustomUserPreferences = {
      NSGlobalDomain = {
        AppleMenuBarVisibleInFullscreen = 1;
      };
      # Hot corner modifier
      com.apple.dock = {
        wvous-tl-modifier = 0; # None
        wvous-tr-modifier = 262144; # Ctrl
        wvous-bl-modifier = 0; # None
        wvous-br-modifier = 262144; # Ctrl
      };
      com.apple.desktopservices = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
    };
  };
}
