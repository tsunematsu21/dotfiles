{
  username,
  homeDirectory,
  ...
}:
{
  imports = [
    ./activation.nix
    ./agent-skills.nix
    ./files.nix
    ./tools.nix
  ];

  home = {
    inherit username homeDirectory;
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
