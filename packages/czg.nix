{
  fetchurl,
  lib,
  nodejs,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "czg";
  version = "1.13.1";

  src = fetchurl {
    url = "https://registry.npmjs.org/czg/-/czg-${version}.tgz";
    hash = "sha256-stnVZz8gNXIYkiB48FffwK1X0TZ8tCJKzC7OURqGBI0=";
  };

  nativeBuildInputs = [ nodejs ];

  unpackPhase = ''
    runHook preUnpack
    tar -xzf "$src"
    cd package
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/node_modules/czg" "$out/bin"
    cp -R . "$out/lib/node_modules/czg"

    patchShebangs "$out/lib/node_modules/czg/bin"

    ln -s "$out/lib/node_modules/czg/bin/index.js" "$out/bin/czg"
    ln -s "$out/lib/node_modules/czg/bin/index.js" "$out/bin/git-czg"

    runHook postInstall
  '';

  meta = {
    description = "Interactive Commitizen CLI that generates standardized git commit messages";
    homepage = "https://cz-git.qbb.sh/cli/";
    license = lib.licenses.mit;
    mainProgram = "czg";
    platforms = lib.platforms.all;
  };
}
