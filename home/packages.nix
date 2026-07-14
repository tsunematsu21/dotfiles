{ inputs, pkgs, ... }:
let
  llm-agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages = with pkgs; [
    awscli
    bat
    betterleaks
    deadnix
    fastfetch
    fd
    fzf
    ghq
    git
    go
    jq
    lazygit
    lefthook
    mise
    neovim
    poppler
    ripgrep
    rustup
    sheldon
    starship
    statix
    stow
    tlrc
    usage
    yazi
    zoxide

    llm-agents.codex
    llm-agents.herdr

    (callPackage ../packages/czg.nix { })
    (callPackage ../packages/plamo-translate.nix { })
    (callPackage ../packages/safe-chain.nix { })
  ];
}
