{ inputs, ... }:

{
  flake.modules.homeManager.packages =
    { pkgs, ... }:
    let
      llm-agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      home.packages = with pkgs; [
        # keep-sorted start
        awscli
        bat
        betterleaks
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
        stow
        tlrc
        tree-sitter
        usage
        yazi
        zoxide
        # keep-sorted end

        llm-agents.codex
        llm-agents.herdr

        (callPackage ../../packages/czg.nix { })
        (callPackage ../../packages/plamo-translate.nix { })
        (callPackage ../../packages/safe-chain.nix { })
      ];

      programs.gh = {
        enable = true;
        settings = {
          git_protocol = "https";
          prompt = "enabled";
          aliases.co = "pr checkout";
        };
        extensions = [
          pkgs.gh-dash
          inputs.gh-q.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
      };
    };
}
