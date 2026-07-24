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
