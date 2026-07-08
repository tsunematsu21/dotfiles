{
  fetchurl,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "safe-chain";
  version = "1.5.12";

  src = fetchurl {
    url = "https://github.com/AikidoSec/safe-chain/releases/download/${version}/safe-chain-macos-arm64";
    hash = "sha256-Mqv+hl+N3HubjQarEQWxsB4tH5xz05joDzQhyzRB5fY=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 "$src" "$out/libexec/safe-chain/safe-chain"
    mkdir -p "$out/bin"
    cat > "$out/bin/safe-chain" <<EOF
    #!/bin/sh
    set -e

    install_dir="\''${SAFE_CHAIN_NIX_INSTALL_DIR:-"\$HOME/.safe-chain/nix-bin"}"
    binary="\$install_dir/safe-chain"
    source_binary="$out/libexec/safe-chain/safe-chain"

    mkdir -p "\$install_dir"
    if [ ! -x "\$binary" ] || ! cmp -s "\$source_binary" "\$binary"; then
      cp "\$source_binary" "\$binary"
      chmod +x "\$binary"
    fi

    exec "\$binary" "\$@"
    EOF
    chmod +x "$out/bin/safe-chain"

    runHook postInstall
  '';

  meta = {
    description = "Protect package installs from malicious code";
    homepage = "https://github.com/AikidoSec/safe-chain";
    license = lib.licenses.asl20;
    mainProgram = "safe-chain";
    platforms = [ "aarch64-darwin" ];
  };
}
