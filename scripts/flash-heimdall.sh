#!/usr/bin/env bash
set -euo pipefail

script_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
if [[ -f "$script_dir/SHA256SUMS" ]]; then
  default_dir="$script_dir"
else
  default_dir="$script_dir/../release/v1.0.1"
fi

mode="${1:-}"
if [[ "$mode" != "--flash" && "$mode" != "--flash-no-wipe" && "$mode" != "--twrp-only-no-wipe" ]]; then
  echo "Usage: $0 --flash [release-directory]" >&2
  echo "       $0 --flash-no-wipe [release-directory]" >&2
  echo "       $0 --twrp-only-no-wipe [release-directory]" >&2
  exit 2
fi

release_dir="${2:-$default_dir}"
boot="$release_dir/SM-N9750-HZE1-Magisk-Alpha-30700-BOOT-v1.0.1.img"
recovery="$release_dir/SM-N9750-HZE1-TWRP-3.7.1_12-FBE-v1.0.1.img"

command -v heimdall >/dev/null || {
  echo "heimdall is not installed" >&2
  exit 1
}

[[ -f "$recovery" && -f "$release_dir/SHA256SUMS" ]] || {
  echo "Release files are incomplete: $release_dir" >&2
  exit 1
}
if [[ "$mode" != "--twrp-only-no-wipe" && ! -f "$boot" ]]; then
  echo "BOOT image is missing: $boot" >&2
  exit 1
fi

(
  cd "$release_dir"
  sha256sum -c SHA256SUMS
)

[[ "$(stat -c %s "$recovery")" == "82792448" ]] || {
  echo "Unexpected RECOVERY size" >&2
  exit 1
}
if [[ "$mode" != "--twrp-only-no-wipe" ]]; then
  [[ "$(stat -c %s "$boot")" == "67108864" ]] || {
    echo "Unexpected BOOT size" >&2
    exit 1
  }
fi

echo "WARNING: only SM-N9750 on N9750ZSU6HZE1 is supported."
echo "The flash command does not erase USERDATA, but the bootloader must already be unlocked."
echo "Unlocking it for the first time always wipes data and permanently trips Knox."
if [[ "$mode" == "--twrp-only-no-wipe" ]]; then
  echo "RECOVERY-only mode selected: Android data and BOOT will not be touched."
  echo "On a stock BOOT, Samsung may restore stock recovery after the next Android boot."
else
  echo "BOOT+RECOVERY mode selected: persistent TWRP and Magisk Alpha normal boot."
fi
read -r -p "Type SM-N9750-HZE1 to continue: " confirmation
[[ "$confirmation" == "SM-N9750-HZE1" ]] || {
  echo "Cancelled" >&2
  exit 1
}

heimdall detect
if [[ "$mode" == "--twrp-only-no-wipe" ]]; then
  heimdall flash --RECOVERY "$recovery" --no-reboot
else
  heimdall flash --BOOT "$boot" --RECOVERY "$recovery" --no-reboot
fi

echo
echo "Flash complete. Keep USB connected."
echo "Hold Volume Down + Side/Power until black, then immediately"
echo "switch to Volume Up + Side/Power and release when TWRP appears."
