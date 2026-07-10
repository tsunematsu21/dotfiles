{ config, homeDirectory, ... }:
let
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/${path}";
  mkLinks = paths: builtins.mapAttrs (_: path: { source = mkLink path; }) paths;
in
{
  home.file = mkLinks {
    ".aws" = "config/aws";
    ".ssh" = "config/ssh";
    ".zprofile" = "config/zsh/.zprofile";
    ".zshrc" = "config/zsh/.zshrc";
  };

  xdg.configFile = mkLinks {
    "ghostty" = "config/ghostty";
    "git" = "config/git";
    "herdr" = "config/herdr";
    "lazygit" = "config/lazygit";
    "mise" = "config/mise";
    "nvim" = "config/nvim";
    "sheldon" = "config/sheldon";
    "starship.toml" = "config/starship.toml";
    "yazi" = "config/yazi";
  };
}
