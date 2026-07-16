{
  description = "My dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    llm-agents.url = "github:numtide/llm-agents.nix";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    gh-q.url = "github:kawarimidoll/gh-q";
    gh-q.inputs.nixpkgs.follows = "nixpkgs";

    skill-find-skills.url = "github:vercel-labs/skills";
    skill-find-skills.flake = false;
    skill-herdr.url = "github:ogulcancelik/herdr";
    skill-herdr.flake = false;
    skill-systematic-debugging.url = "github:obra/superpowers";
    skill-systematic-debugging.flake = false;
    skill-verification-before-completion.follows = "skill-systematic-debugging";
  };

  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      treefmt-nix,
      ...
    }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
      treefmtEval = treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";
        programs = {
          nixfmt.enable = true;
          stylua.enable = true;
          taplo.enable = true;
          yamlfmt.enable = true;
        };
      };
      mkSystem = import ./lib/mk-system.nix { inherit inputs self; };
    in
    {
      formatter.${system} = treefmtEval.config.build.wrapper;
      checks.${system}.formatting = treefmtEval.config.build.check self;

      darwinConfigurations.mac = mkSystem {
        inherit system;
        username = "masato.tsunematsu";
      };
    };
}
