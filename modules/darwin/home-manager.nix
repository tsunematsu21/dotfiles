{ inputs, ... }:

{
  flake.modules.darwin.home-manager = { hostConfig, ... }: {
    imports = [ inputs.home-manager.darwinModules.home-manager ];

    users.users.${hostConfig.username}.home = hostConfig.homeDirectory;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs hostConfig; };
      users.${hostConfig.username}.imports = hostConfig.homeModules;
    };
  };
}
