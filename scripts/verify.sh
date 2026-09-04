#!/usr/bin/env bash
set -euo pipefail

script_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
if [[ -f "$script_dir/SHA256SUMS" ]]; then
  default_dir="$script_dir"
else
  default_dir="$script_dir/../release/v1.0.1"
fi
release_dir="${1:-$default_dir}"

if [[ ! -f "$release_dir/SHA256SUMS" ]]; then
  echo "SHA256SUMS not found in: $release_dir" >&2
  exit 1
fi

cd "$release_dir"
sha256sum -c SHA256SUMS
