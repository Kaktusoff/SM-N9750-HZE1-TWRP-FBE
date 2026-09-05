#!/usr/bin/env bash
set -euo pipefail

script_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
repo_dir="$(CDPATH= cd -- "$script_dir/.." && pwd)"
source_dir="${1:-$repo_dir/release/v1.0.1}"
output_dir="${2:-$repo_dir/release/odin}"

boot_source="$source_dir/SM-N9750-HZE1-Magisk-Alpha-30700-BOOT-v1.0.1.img"
recovery_source="$source_dir/SM-N9750-HZE1-TWRP-3.7.1_12-FBE-v1.0.1.img"
boot_sha256="027447589dc1845d65d6018df5322d54b01410e939a441e0fdcf63ae9c12a8c5"
recovery_sha256="d8b050f0d342abde7339a95c5a255098a004399ff1ec78d33b0b151cf2967415"

paired_name="AP_SM-N9750_HZE1_TWRP-Magisk-Alpha_v1.0.1.tar.md5"
twrp_name="AP_SM-N9750_HZE1_TWRP-only_v1.0.1.tar.md5"

for tool in lz4 tar md5sum sha256sum; do
  command -v "$tool" >/dev/null || {
    echo "Required tool is missing: $tool" >&2
    exit 1
  }
done

[[ -f "$boot_source" ]] || { echo "BOOT image not found: $boot_source" >&2; exit 1; }
[[ -f "$recovery_source" ]] || {
  echo "RECOVERY image not found: $recovery_source" >&2
  exit 1
}

[[ "$(sha256sum "$boot_source" | awk '{print $1}')" == "$boot_sha256" ]] || {
  echo "Refusing to package an unexpected BOOT image" >&2
  exit 1
}
[[ "$(sha256sum "$recovery_source" | awk '{print $1}')" == "$recovery_sha256" ]] || {
  echo "Refusing to package an unexpected RECOVERY image" >&2
  exit 1
}

build_dir="$(mktemp -d "${TMPDIR:-/tmp}/n9750-odin.XXXXXX")"
trap 'rm -rf -- "$build_dir"' EXIT
mkdir -p "$build_dir/stage" "$build_dir/check" "$output_dir"

lz4 -f -B6 --content-size "$boot_source" "$build_dir/stage/boot.img.lz4"
lz4 -f -B6 --content-size "$recovery_source" "$build_dir/stage/recovery.img.lz4"

build_odin_archive() {
  local output_name="$1"
  shift
  local tar_path="$output_dir/${output_name%.md5}"
  local md5

  tar --create \
    --format=ustar \
    --owner=0 --group=0 --numeric-owner \
    --mode=0644 \
    --mtime='UTC 2026-09-05 00:00:00' \
    --sort=name \
    --file="$tar_path" \
    --directory="$build_dir/stage" \
    "$@"

  md5="$(md5sum "$tar_path" | awk '{print $1}')"
  printf '%s  %s\n' "$md5" "$(basename "$tar_path")" >> "$tar_path"
  mv -- "$tar_path" "$output_dir/$output_name"
}

build_odin_archive "$paired_name" boot.img.lz4 recovery.img.lz4
build_odin_archive "$twrp_name" recovery.img.lz4

verify_odin_archive() {
  local archive="$1"
  shift
  local footer footer_size payload_size recorded_md5 actual_md5 check_dir tar_name

  tar_name="$(basename "${archive%.md5}")"
  footer_size=$((32 + 2 + ${#tar_name} + 1))
  footer="$(tail -c "$footer_size" "$archive")"
  recorded_md5="${footer:0:32}"
  payload_size=$(($(stat -c %s "$archive") - footer_size))
  check_dir="$build_dir/check/$(basename "$archive")"
  mkdir -p "$check_dir"

  head -c "$payload_size" "$archive" > "$check_dir/payload.tar"
  actual_md5="$(md5sum "$check_dir/payload.tar" | awk '{print $1}')"
  [[ "$actual_md5" == "$recorded_md5" ]] || {
    echo "Invalid Odin MD5 footer: $archive" >&2
    exit 1
  }

  tar -xf "$check_dir/payload.tar" -C "$check_dir" "$@"
  for member in "$@"; do
    lz4 -t "$check_dir/$member" >/dev/null
  done
}

verify_odin_archive "$output_dir/$paired_name" boot.img.lz4 recovery.img.lz4
verify_odin_archive "$output_dir/$twrp_name" recovery.img.lz4

[[ "$(lz4 -dc "$build_dir/check/$paired_name/boot.img.lz4" | sha256sum | awk '{print $1}')" == "$boot_sha256" ]]
[[ "$(lz4 -dc "$build_dir/check/$paired_name/recovery.img.lz4" | sha256sum | awk '{print $1}')" == "$recovery_sha256" ]]
[[ "$(lz4 -dc "$build_dir/check/$twrp_name/recovery.img.lz4" | sha256sum | awk '{print $1}')" == "$recovery_sha256" ]]

(
  cd "$output_dir"
  sha256sum "$paired_name" "$twrp_name" > SHA256SUMS-ODIN.txt
)

echo "Built and verified Odin packages:"
du -h "$output_dir/$paired_name" "$output_dir/$twrp_name"
cat "$output_dir/SHA256SUMS-ODIN.txt"
