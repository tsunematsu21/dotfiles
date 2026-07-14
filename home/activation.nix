{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.activation.preparePrivateDirectories =
    lib.hm.dag.entryBetween [ "linkGeneration" ] [ "writeBoundary" ]
      ''
        $DRY_RUN_CMD ${pkgs.coreutils}/bin/install -d -m 700 \
          "${config.home.homeDirectory}/.aws" \
          "${config.home.homeDirectory}/.ssh" \
          "${config.xdg.configHome}/herdr"
      '';

  home.activation.setupSafeChainAndMise = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${config.home.path}/bin/safe-chain setup-ci
    export PATH="$HOME/.safe-chain/shims:${pkgs.mise}/bin:$PATH"
    ${pkgs.mise}/bin/mise install
  '';
}
