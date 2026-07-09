{
  config,
  pkgs,
  lib,
  username,
  homeDirectory,
  ...
}:
let
  dotfilesPath = "${homeDirectory}/dotfiles";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
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

  home.file = {
    ".zprofile".source = mkLink "config/zsh/.zprofile";
    ".zshrc".source = mkLink "config/zsh/.zshrc";
    ".ssh".source = mkLink "config/ssh/";
    ".aws".source = mkLink "config/aws/";
  };

  xdg.configFile = {
    "ghostty".source = mkLink "config/ghostty";
    "herdr".source = mkLink "config/herdr";
    "git".source = mkLink "config/git";
    "gh".source = mkLink "config/gh";
    "sheldon".source = mkLink "config/sheldon";
    "starship.toml".source = mkLink "config/starship.toml";
    "mise".source = mkLink "config/mise";
    "lazygit".source = mkLink "config/lazygit";
    "yazi".source = mkLink "config/yazi";
    "nvim".source = mkLink "config/nvim";
  };

  home.activation = {
    runMiseInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${pkgs.safe-chain}/bin/safe-chain setup-ci
      export PATH="$HOME/.safe-chain/shims:${pkgs.mise}/bin:$PATH"
      ${pkgs.mise}/bin/mise install
    '';
  };

  programs.home-manager.enable = true;
}
