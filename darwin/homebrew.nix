{ username, ... }:
{
  nix-homebrew = {
    enable = true;
    user = username;
    enableRosetta = false;
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    user = username;
    onActivation.cleanup = "none";
    casks = [
      "chatgpt"
      "font-hackgen-nerd"
      "ghostty"
      "google-chrome"
      "notion"
      "raycast"
      "visual-studio-code"
    ];
  };
}
