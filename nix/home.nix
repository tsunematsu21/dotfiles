{
  config,
  pkgs,
  lib,
  username,
  homeDirectory,
  ...
}:
let
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/${path}";
  mkLinks = paths: builtins.mapAttrs (_: path: { source = mkLink path; }) paths;
in
{
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    # Shell and terminal tools
    fd
    fzf
    jq
    ripgrep
    zoxide
    sheldon
    starship
    fastfetch
    stow
    tlrc
    poppler
    yazi

    # Development tools
    awscli
    gh
    git
    lazygit
    neovim
    lefthook
    betterleaks
    czg
    safe-chain

    # Languages and tool version management
    go
    mise
    rustup

    # from llm-agents.nix
    codex
    herdr
  ];

  home.file = mkLinks {
    ".aws" = "config/aws";
    ".ssh" = "config/ssh";
    ".zprofile" = "config/zsh/.zprofile";
    ".zshrc" = "config/zsh/.zshrc";
  };

  xdg.configFile = mkLinks {
    "gh" = "config/gh";
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

  home.activation = {
    setupSafeChainAndMise = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${pkgs.safe-chain}/bin/safe-chain setup-ci
      export PATH="$HOME/.safe-chain/shims:${pkgs.mise}/bin:$PATH"
      ${pkgs.mise}/bin/mise install
    '';
  };

  programs.home-manager.enable = true;
}
