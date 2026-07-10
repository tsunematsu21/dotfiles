{
  lib,
  writeShellApplication,
  uv,
}:

writeShellApplication {
  name = "plamo-translate";

  runtimeInputs = [ uv ];

  text = ''
    real_binary="$HOME/.local/bin/plamo-translate"

    if ! "$real_binary" --help >/dev/null 2>&1; then
      echo "plamo-translate not found or broken. Installing with uv..." >&2
      overrides="$(mktemp)"
      trap 'rm -f "$overrides"' EXIT
      # Upstream pyproject.toml has tool.uv.override-dependencies = ["transformers<5"].
      # Keep the same constraint for uv tool installs; otherwise uv may select
      # transformers 5.x, which currently breaks mlx-lm tokenizer registration.
      printf 'transformers<5\n' > "$overrides"
      uv tool install --force -p 3.14 --overrides "$overrides" "plamo-translate==1.0.5" >&2
    fi

    export TMPDIR="''${TMPDIR:-/tmp}"
    exec "$real_binary" "$@"
  '';

  meta = {
    description = "CLI for translation using the plamo-2-translate model with local execution";
    homepage = "https://github.com/pfnet/plamo-translate-cli";
    license = lib.licenses.asl20;
    mainProgram = "plamo-translate";
    platforms = lib.platforms.darwin;
  };
}
