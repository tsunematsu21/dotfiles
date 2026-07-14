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

  homeManagerModule = {
    users.users.${username}.home = homeDirectory;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs username homeDirectory;
      };
      users.${username} = import ../home;
    };
  };
in
inputs.nix-darwin.lib.darwinSystem {
  inherit system;

  specialArgs = {
    inherit self system username;
  };

  modules = [
    ../darwin
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
    homeManagerModule
  ]
  ++ modules;
}
