#!/usr/bin/env bash
set -euo pipefail

name="Tricky-Store-v1.4.1-245-72b2e84-release.zip"
url="https://github.com/5ec1cff/TrickyStore/releases/download/1.4.1/$name"
sha256="2f5e73fcba0e4e43b6e96b38f333cbe394873e3a81cf8fe1b831c2fbd6c46ea9"
output="${1:-$name}"

command -v curl >/dev/null || { echo "curl is required" >&2; exit 1; }
curl -fL --retry 3 -o "$output.part" "$url"
printf '%s  %s\n' "$sha256" "$output.part" | sha256sum -c -
mv -- "$output.part" "$output"
echo "Saved verified upstream file: $output"
