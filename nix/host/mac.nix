{ inputs, self, ... }:

let
  system = "aarch64-darwin";
  username = "masato.tsunematsu";
  homeDirectory = "/Users/${username}";
in
inputs.nix-darwin.lib.darwinSystem {
  inherit system;
  specialArgs = {
    inherit self system username;
    nix-homebrew = inputs.nix-homebrew;
  };
  modules = [
    ../darwin.nix
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
    {
      nixpkgs.overlays = [
        inputs.llm-agents.overlays.default
      ];
      users.users.${username}.home = homeDirectory;
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs username homeDirectory; };
        users.${username} = import ../home.nix;
      };
    }
  ];
}
