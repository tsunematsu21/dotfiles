{
  lib,
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
    #USAGE cmd "rebuild" help="Apply the host configuration"
    #USAGE cmd "update" help="Update flake inputs and rebuild"

    case "$1" in
      rebuild)
        shift
        exec sudo /run/current-system/sw/bin/darwin-rebuild switch --flake "${dotfilesDirectory}#${hostname}" "$@"
        ;;

      update)
        shift
        cd "${dotfilesDirectory}"
        ${lib.getExe nix} flake update
        exec sudo /run/current-system/sw/bin/darwin-rebuild switch --flake "${dotfilesDirectory}#${hostname}" "$@"
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
