{
  config,
  pkgs,
  lib,
  username,
  homeDirectory,
  ...
}:
let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = homeDirectory;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
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

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
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

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/masato.tsunematsu/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
