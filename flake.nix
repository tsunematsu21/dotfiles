{
  description = "Home Manager configuration of masato.tsunematsu";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    llm-agents.url = "github:numtide/llm-agents.nix";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

  outputs = inputs@{ self, home-manager, nix-darwin, llm-agents, nix-homebrew, ... }:
    let
      username = "masato.tsunematsu";
      homeDirectory = "/Users/${username}";
    in
    {
      darwinConfigurations."MacBook-Air" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit self username nix-homebrew; };
        modules = [
          ./darwin.nix
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
          {
            nixpkgs.overlays = [ llm-agents.overlays.default ];
            users.users.${username}.home = homeDirectory;
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs username homeDirectory; };
              users.${username} = import ./home.nix;
            };
          }
        ];
      };
    };
}
