#!/usr/bin/env bash
set -euo pipefail

script_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
repo_dir="$(CDPATH= cd -- "$script_dir/.." && pwd)"

input_boot="${1:-}"
magiskboot="${2:-}"
output_boot="${3:-$repo_dir/release/v1.0.1/SM-N9750-HZE1-Magisk-Alpha-30700-BOOT-v1.0.1.img}"
overlay="$repo_dir/source/boot-overlay/twrp-survival.rc"

input_sha256="9dd7c4f948bf9f314f111ea42b5abd9641931b0f9282c33e031d3854bb7baf00"
output_sha256="027447589dc1845d65d6018df5322d54b01410e939a441e0fdcf63ae9c12a8c5"
partition_size="67108864"

if [[ -z "$input_boot" || -z "$magiskboot" ]]; then
  echo "Usage: $0 ALPHA_PATCHED_BOOT MAGISKBOOT [OUTPUT_BOOT]" >&2
  exit 2
fi

for file in "$input_boot" "$magiskboot" "$overlay"; do
  [[ -f "$file" ]] || { echo "Missing input: $file" >&2; exit 1; }
done

[[ "$(sha256sum "$input_boot" | awk '{print $1}')" == "$input_sha256" ]] || {
  echo "Refusing unexpected Alpha BOOT input" >&2
  exit 1
}

build_dir="$(mktemp -d "${TMPDIR:-/tmp}/n9750-alpha-boot.XXXXXX")"
trap 'rm -rf -- "$build_dir"' EXIT
cp -- "$input_boot" "$build_dir/boot.img"

(
  cd "$build_dir"
  "$magiskboot" unpack boot.img
  "$magiskboot" cpio ramdisk.cpio \
    "add 0644 overlay.d/twrp-survival.rc $overlay"
  "$magiskboot" repack boot.img new-boot.img
  truncate -s "$partition_size" new-boot.img
)

mkdir -p "$(dirname -- "$output_boot")"
mv -- "$build_dir/new-boot.img" "$output_boot"

[[ "$(stat -c %s "$output_boot")" == "$partition_size" ]]
[[ "$(sha256sum "$output_boot" | awk '{print $1}')" == "$output_sha256" ]] || {
  echo "Rebuilt BOOT does not match the device-tested v1.0.1 image" >&2
  exit 1
}

echo "Built verified v1.0.1 BOOT:"
sha256sum "$output_boot"
