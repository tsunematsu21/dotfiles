{
  description = "Home Manager configuration of masato.tsunematsu";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    llm-agents.url = "github:numtide/llm-agents.nix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
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
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./nix/treefmt.nix;

      commonDarwinModules = [
        ./nix/darwin.nix
        inputs.home-manager.darwinModules.home-manager
        inputs.nix-homebrew.darwinModules.nix-homebrew
        {
          nixpkgs.overlays = [
            inputs.llm-agents.overlays.default
            (final: _prev: {
              czg = final.callPackage ./nix/packages/czg.nix { };
              safe-chain = final.callPackage ./nix/packages/safe-chain.nix { };
            })
          ];
        }
      ];

      mkDarwinConfiguration =
        host:
        inputs.nix-darwin.lib.darwinSystem {
          inherit (host) system;
          specialArgs = {
            inherit self;
            inherit (host) system username;
          };
          modules =
            commonDarwinModules
            ++ [
              {
                users.users.${host.username}.home = host.homeDirectory;
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = {
                    inherit (host) username homeDirectory;
                  };
                  users.${host.username} = import ./nix/home.nix;
                };
              }
            ]
            ++ (host.modules or [ ]);
        };
    in
    {
      formatter.${system} = treefmtEval.config.build.wrapper;
      checks.${system}.formatting = treefmtEval.config.build.check self;

      darwinConfigurations.mac = mkDarwinConfiguration (import ./nix/host/mac.nix);
    };
}
