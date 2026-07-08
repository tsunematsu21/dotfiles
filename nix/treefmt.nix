{
  projectRootFile = "flake.nix";

  programs = {
    nixfmt.enable = true;
    shfmt.enable = true;
    taplo.enable = true;
    yamlfmt.enable = true;
  };
}
