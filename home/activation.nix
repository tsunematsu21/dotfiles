{ pkgs, lib, ... }:
{
  home.activation.setupSafeChainAndMise = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.safe-chain}/bin/safe-chain setup-ci
    export PATH="$HOME/.safe-chain/shims:${pkgs.mise}/bin:$PATH"
    ${pkgs.mise}/bin/mise install
  '';
}
