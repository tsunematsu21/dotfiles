{ pkgs, ... }:
{
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
    plamo-translate
    safe-chain

    # Languages and tool version management
    go
    mise
    rustup

    # from llm-agents.nix
    codex
    herdr
  ];
}
