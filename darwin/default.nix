{
  self,
  system,
  username,
  ...
}:
{
  imports = [
    ./defaults.nix
    ./homebrew.nix
  ];

  nixpkgs.hostPlatform = system;
  system = {
    stateVersion = 6;
    configurationRevision = self.rev or self.dirtyRev or null;
    primaryUser = username;
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };
  nix.enable = false;
  programs.zsh.enable = true;
  security.pam.services.sudo_local.touchIdAuth = true;
}
