{
  inputs,
  self,
}:
{
  system,
  username,
  modules ? [ ],
}:
let
  homeDirectory = "/Users/${username}";
in
inputs.nix-darwin.lib.darwinSystem {
  inherit system;

  specialArgs = {
    inherit self system username;
  };

  modules = [
    ./darwin.nix
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
    {
      nixpkgs.overlays = [
        inputs.llm-agents.overlays.default
        (final: _prev: {
          czg = final.callPackage ./packages/czg.nix { };
          safe-chain = final.callPackage ./packages/safe-chain.nix { };
        })
      ];

      users.users.${username}.home = homeDirectory;

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit username homeDirectory;
        };
        users.${username} = import ./home.nix;
      };
    }
  ]
  ++ modules;
}
