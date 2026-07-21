_:

{
  flake.modules.homeManager.files =
    { config, hostConfig, ... }:
    let
      mkLink = path: config.lib.file.mkOutOfStoreSymlink "${hostConfig.dotfilesDirectory}/${path}";
      mkLinks = paths: builtins.mapAttrs (_: path: { source = mkLink path; }) paths;
    in
    {
      home.file =
        mkLinks {
          ".ssh/config" = "config/ssh/config";
          ".zprofile" = "config/zsh/.zprofile";
          ".zshrc" = "config/zsh/.zshrc";
        }
        // {
          "Library/Application Support/Tuna/config.toml" = {
            source = mkLink "config/tuna/config.toml";
            force = true;
          };
        };

      xdg.configFile = mkLinks {
        "ghostty" = "config/ghostty";
        "git/config" = "config/git/config";
        "git/ignore" = "config/git/ignore";
        "herdr/config.toml" = "config/herdr/config.toml";
        "hunk/config.toml" = "config/hunk/config.toml";
        "lazygit" = "config/lazygit";
        "leaf/config.toml" = "config/leaf/config.toml";
        "mise" = "config/mise";
        "nvim" = "config/nvim";
        "omniwm" = "config/omniwm";
        "sheldon" = "config/sheldon";
        "starship.toml" = "config/starship.toml";
        "yazi" = "config/yazi";
      };
    };
}
