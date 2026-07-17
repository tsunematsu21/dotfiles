{
  description = "My dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    llm-agents.url = "github:numtide/llm-agents.nix";

    gh-q.url = "github:kawarimidoll/gh-q";
    gh-q.inputs.nixpkgs.follows = "nixpkgs";

    skill-find-skills.url = "github:vercel-labs/skills";
    skill-find-skills.flake = false;
    skill-herdr.url = "github:ogulcancelik/herdr";
    skill-herdr.flake = false;
    skill-systematic-debugging.url = "github:obra/superpowers";
    skill-systematic-debugging.flake = false;
    skill-verification-before-completion.follows = "skill-systematic-debugging";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  outputs =
    inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { config, lib, ... }: {
        systems = [ "aarch64-darwin" ];

        imports = [
          inputs.flake-parts.flakeModules.modules
          inputs.treefmt-nix.flakeModule
          (inputs.import-tree ./modules)
        ];

        flake.darwinConfigurations."mac" = inputs.nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs self;
            hostConfig = rec {
              username = "masato.tsunematsu";
              platform = "aarch64-darwin";
              homeDirectory = "/Users/${username}";
              dotfilesDirectory = "${homeDirectory}/dotfiles";
              homeModules = with config.flake.modules.homeManager; [
                base
                activation
                agent-skills
                files
                packages
              ];
            };
          };
          modules = with config.flake.modules; [
            darwin.base
            darwin.homebrew
            darwin.defaults
            darwin.home-manager
          ];
        };

        flake.checks = lib.foldlAttrs (
          acc: name: darwin:
          let
            system = darwin.config.nixpkgs.hostPlatform.system;
          in
          lib.recursiveUpdate acc {
            ${system}."darwin-${name}" = darwin.config.system.build.toplevel;
          }
        ) { } config.flake.darwinConfigurations;

        perSystem = _: {
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              # keep-sorted start
              deadnix.enable = true;
              keep-sorted.enable = true;
              nixfmt.enable = true;
              statix.enable = true;
              stylua.enable = true;
              taplo.enable = true;
              yamlfmt.enable = true;
              # keep-sorted end
            };
          };
        };
      }
    );
}
