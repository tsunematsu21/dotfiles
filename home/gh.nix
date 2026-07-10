{ inputs, pkgs, ... }:
{
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
      prompt = "enabled";
      aliases.co = "pr checkout";
    };
    extensions = [
      pkgs.gh-dash
      inputs.gh-q.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
