eval "$(/opt/homebrew/bin/brew shellenv)"

if [[ -o interactive ]]; then
  fastfetch
fi
