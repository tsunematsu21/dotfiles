_:

{
  flake.modules.darwin.base = { self, hostConfig, ... }: {
    networking.computerName = hostConfig.codename;
    networking.hostName = hostConfig.hostname;

    nixpkgs.hostPlatform = hostConfig.platform;

    system = {
      stateVersion = 6;
      configurationRevision = self.rev or self.dirtyRev or null;
      primaryUser = hostConfig.username;
      keyboard = {
        enableKeyMapping = true;
        remapCapsLockToControl = true;
      };
    };

    nix.enable = false;

    # Nix is installed outside nix-darwin, so schedule its garbage collector
    # directly instead of using nix.gc (which requires nix.enable).
    launchd.daemons.nix-gc = {
      command = "/nix/var/nix/profiles/default/bin/nix-collect-garbage --delete-older-than 7d";
      serviceConfig = {
        RunAtLoad = false;
        StartCalendarInterval = {
          Weekday = 0;
          Hour = 3;
          Minute = 0;
        };
      };
    };

    programs.zsh = {
      enable = true;
      enableGlobalCompInit = false;
    };

    security.pam.services.sudo_local = {
      touchIdAuth = true;
      watchIdAuth = true;
    };

    system.activationScripts.postActivation.text = ''
      echo >&2 "restarting Dock after Homebrew..."
      killall -qu ${hostConfig.username} Dock || true
    '';
  };
}
