{
  self,
  system,
  username,
  ...
}:
{
  nixpkgs.hostPlatform = system;
  system = {
    stateVersion = 6;
    configurationRevision = self.rev or self.dirtyRev or null;
    primaryUser = username;
  };
  nix.enable = false;
  programs.zsh.enable = true;

  nix-homebrew = {
    enable = true;
    user = username;
    enableRosetta = false;
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    user = username;
    # See: https://mynixos.com/nix-darwin/option/homebrew.onActivation.cleanup
    onActivation.cleanup = "none";
    casks = [
      "chatgpt"
      "codex-app"
      "ghostty"
      "google-chrome"
      "notion"
      "raycast"
      "visual-studio-code"
      "font-hackgen-nerd"
    ];
  };

  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      AppleShowScrollBars = "Always";
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      "com.apple.keyboard.fnState" = true;
      "com.apple.trackpad.scaling" = 3.0;
    };

    ".GlobalPreferences" = {
      "com.apple.mouse.scaling" = 3.0;
    };

    hitoolbox.AppleFnUsageType = "Change Input Source";

    trackpad = {
      FirstClickThreshold = 0;
      TrackpadThreeFingerDrag = true;
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXDefaultSearchScope = "SCcf"; # Current folder
      FXPreferredViewStyle = "Nlsv"; # List view
      FXRemoveOldTrashItems = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    dock = {
      autohide = true;
      autohide-delay = 0.2;
      autohide-time-modifier = 1.0;
      mineffect = "suck";
      orientation = "bottom";
      scroll-to-open = true;
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
      show-thumbnail = true;
      type = "png";
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
  };
}
