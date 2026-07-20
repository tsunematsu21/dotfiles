{
  lib,
  neovim,
  nix,
  usage,
  writeTextFile,
  dotfilesDirectory,
  hostname,
}:

writeTextFile {
  name = "dotfiles";
  destination = "/bin/dotfiles";
  executable = true;

  text = ''
    #!${lib.getExe usage} bash
    #USAGE about "Manage the dotfiles configuration"
    #USAGE cmd "diff" help="Build and compare the Nix system closure"
    #USAGE cmd "edit" help="Open the dotfiles directory in the editor"
    #USAGE cmd "rebuild" help="Apply the host configuration"
    #USAGE cmd "update" help="Update flake inputs and compare the Nix system closure"

    set -eu

    build_and_diff() {
      echo "Building the system configuration..."
      system="$(${lib.getExe nix} build --no-link --print-out-paths \
        "${dotfilesDirectory}#darwinConfigurations.${hostname}.system" "$@")"

      echo "Comparing with the current system..."
      closure_diff="$(${lib.getExe nix} store diff-closures /run/current-system "$system")"
      if [ -n "$closure_diff" ]; then
        printf '%s\n' "$closure_diff"
      else
        echo "No Nix closure changes."
      fi
    }

    case "$1" in
      diff)
        shift
        cd "${dotfilesDirectory}"
        build_and_diff "$@"
        ;;

      edit)
        shift
        editor="''${EDITOR:-${lib.getExe neovim}}"
        exec "$editor" "${dotfilesDirectory}"
        ;;

      rebuild)
        shift
        exec sudo /run/current-system/sw/bin/darwin-rebuild switch --flake "${dotfilesDirectory}#${hostname}" "$@"
        ;;

      update)
        shift
        cd "${dotfilesDirectory}"
        ${lib.getExe nix} flake update
        build_and_diff "$@"
        ;;
    esac
  '';

  meta = {
    description = "Manage the dotfiles configuration";
    license = lib.licenses.mit;
    mainProgram = "dotfiles";
    platforms = lib.platforms.darwin;
  };
}
