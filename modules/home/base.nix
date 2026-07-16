_:

{
  flake.modules.homeManager.base = { hostConfig, ... }: {
    home = {
      inherit (hostConfig) username homeDirectory;
      stateVersion = "26.05";
    };

    programs.home-manager.enable = true;
  };
}
