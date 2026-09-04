#!/usr/bin/env bash
set -euo pipefail

script_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
if [[ -f "$script_dir/SHA256SUMS" ]]; then
  default_dir="$script_dir"
else
  default_dir="$script_dir/../release/v1.0.0"
fi

if [[ "${1:-}" != "--flash" ]]; then
  echo "Usage: $0 --flash [release-directory]" >&2
  exit 2
fi

release_dir="${2:-$default_dir}"
boot="$release_dir/SM-N9750-HZE1-Magisk-v30.7-BOOT-v1.0.0.img"
recovery="$release_dir/SM-N9750-HZE1-TWRP-3.7.1_12-FBE-v1.0.0.img"

command -v heimdall >/dev/null || {
  echo "heimdall is not installed" >&2
  exit 1
}

[[ -f "$boot" && -f "$recovery" && -f "$release_dir/SHA256SUMS" ]] || {
  echo "Release files are incomplete: $release_dir" >&2
  exit 1
}

(
  cd "$release_dir"
  sha256sum -c SHA256SUMS
)

[[ "$(stat -c %s "$boot")" == "67108864" ]] || {
  echo "Unexpected BOOT size" >&2
  exit 1
}
[[ "$(stat -c %s "$recovery")" == "82792448" ]] || {
  echo "Unexpected RECOVERY size" >&2
  exit 1
}

echo "WARNING: only SM-N9750 on N9750ZSU6HZE1 is supported."
echo "Bootloader unlock wipes data and permanently trips Knox."
read -r -p "Type SM-N9750-HZE1 to continue: " confirmation
[[ "$confirmation" == "SM-N9750-HZE1" ]] || {
  echo "Cancelled" >&2
  exit 1
}

heimdall detect
heimdall flash --BOOT "$boot" --RECOVERY "$recovery" --no-reboot

echo
echo "Flash complete. Keep USB connected."
echo "Hold Volume Down + Side/Power until black, then immediately"
echo "switch to Volume Up + Side/Power and release when TWRP appears."
