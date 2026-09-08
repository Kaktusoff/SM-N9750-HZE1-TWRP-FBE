#!/usr/bin/env bash
set -euo pipefail

script_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
repo_dir="$(CDPATH= cd -- "$script_dir/.." && pwd)"

input_boot="${1:-}"
magiskboot="${2:-}"
output_boot="${3:-$repo_dir/release/v1.0.2/SM-N9750-HZE1-Magisk-Alpha-31000-BOOT-v1.0.2.img}"
overlay="$repo_dir/source/boot-overlay/twrp-survival.rc"

input_sha256="18668911766675676de80a73a5599052ed4fc47c23d12b6c87da66b8dc9c96e0"
magiskboot_sha256="ea75355c880871d67f4a28aa02401a0e679eee8103ee05147451374ba909d022"
overlay_sha256="a7cd0c4eae5da67344c4e2641b926ada35284e5e7bf68fc42807c849a9573deb"
output_sha256="3e0bf40a2e4d64dce1924d37c7e06a1fb3777079d7b1ce027563ad483240f8c4"
partition_size="67108864"

if [[ -z "$input_boot" || -z "$magiskboot" ]]; then
  echo "Usage: $0 ALPHA_31000_PATCHED_BOOT MAGISKBOOT [OUTPUT_BOOT]" >&2
  exit 2
fi

for file in "$input_boot" "$magiskboot" "$overlay"; do
  [[ -f "$file" ]] || { echo "Missing input: $file" >&2; exit 1; }
done

[[ "$(sha256sum "$input_boot" | awk '{print $1}')" == "$input_sha256" ]] || {
  echo "Refusing unexpected Alpha 31000 BOOT input" >&2
  exit 1
}
[[ "$(sha256sum "$magiskboot" | awk '{print $1}')" == "$magiskboot_sha256" ]] || {
  echo "Refusing unexpected Alpha 31000 magiskboot" >&2
  exit 1
}
[[ "$(sha256sum "$overlay" | awk '{print $1}')" == "$overlay_sha256" ]] || {
  echo "Refusing unexpected TWRP-survival overlay" >&2
  exit 1
}

build_dir="$(mktemp -d "${TMPDIR:-/tmp}/n9750-alpha31000-boot.XXXXXX")"
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
  echo "Rebuilt BOOT does not match the device-tested v1.0.2 image" >&2
  exit 1
}

echo "Built verified v1.0.2 BOOT:"
sha256sum "$output_boot"
