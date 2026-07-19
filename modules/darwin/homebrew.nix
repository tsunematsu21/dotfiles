{ inputs, ... }:

{
  flake.modules.darwin.homebrew = { hostConfig, ... }: {
    imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

    nix-homebrew = {
      enable = true;
      user = hostConfig.username;
      enableRosetta = false;
      autoMigrate = true;
    };

    homebrew = {
      enable = true;
      user = hostConfig.username;
      onActivation = {
        autoUpdate = true;
        cleanup = "none";
        upgrade = true;
      };
      brews = [ "leaf-md" ];
      casks = [
        # keep-sorted start
        "chatgpt"
        "font-hackgen-nerd"
        "ghostty"
        "google-chrome"
        "notion"
        "obsidian"
        "sol"
        "visual-studio-code"
        # keep-sorted end
      ];
    };
  };
}
