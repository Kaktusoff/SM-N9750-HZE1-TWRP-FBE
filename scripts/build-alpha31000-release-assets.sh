#!/usr/bin/env bash
set -euo pipefail

script_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
repo_dir="$(CDPATH= cd -- "$script_dir/.." && pwd)"

input_boot="${1:-$repo_dir/release/v1.0.2/SM-N9750-HZE1-Magisk-Alpha-31000-BOOT-v1.0.2.img}"
input_apk="${2:-$repo_dir/release/v1.0.2/Magisk-Alpha-96221b69-31000.apk}"
input_instructions="${3:-$repo_dir/release/v1.0.2/INSTALL_UPDATE_RU_EN.txt}"
output_dir="${4:-$repo_dir/release/v1.0.2-assets}"

expected_boot_sha="3e0bf40a2e4d64dce1924d37c7e06a1fb3777079d7b1ce027563ad483240f8c4"
expected_apk_sha="f77216f829cd0185f58e4b87526544891cca562b8e71a7730856871c24265300"
expected_boot_size="67108864"

boot_name="SM-N9750-HZE1-Magisk-Alpha-31000-BOOT-v1.0.2.img"
apk_name="Magisk-Alpha-96221b69-31000.apk"
odin_name="AP_SM-N9750_HZE1_Magisk-Alpha-31000-BOOT-only_v1.0.2.tar.md5"
instructions_name="INSTALL_UPDATE_RU_EN.txt"
sums_name="SHA256SUMS-v1.0.2.txt"

for tool in lz4 tar md5sum sha256sum stat; do
  command -v "$tool" >/dev/null || {
    echo "Required tool is missing: $tool" >&2
    exit 1
  }
done

[[ -f "$input_boot" && -f "$input_apk" && -f "$input_instructions" ]]
[[ "$(stat -c %s "$input_boot")" == "$expected_boot_size" ]]
[[ "$(sha256sum "$input_boot" | awk '{print $1}')" == "$expected_boot_sha" ]]
[[ "$(sha256sum "$input_apk" | awk '{print $1}')" == "$expected_apk_sha" ]]

mkdir -p "$output_dir"
build_dir="$(mktemp -d "${TMPDIR:-/tmp}/n9750-alpha31000-release.XXXXXX")"
trap 'rm -rf -- "$build_dir"' EXIT
mkdir -p "$build_dir/stage" "$build_dir/check"

install -m 0644 "$input_boot" "$output_dir/$boot_name"
install -m 0644 "$input_apk" "$output_dir/$apk_name"
install -m 0644 "$input_instructions" "$output_dir/$instructions_name"

lz4 -f -B6 --content-size "$input_boot" "$build_dir/stage/boot.img.lz4"
tar --create \
  --format=ustar \
  --owner=0 --group=0 --numeric-owner \
  --mode=0644 \
  --mtime='UTC 2026-09-07 00:00:00' \
  --sort=name \
  --file="$build_dir/${odin_name%.md5}" \
  --directory="$build_dir/stage" \
  boot.img.lz4

tar_path="$build_dir/${odin_name%.md5}"
tar_base="$(basename "$tar_path")"
payload_md5="$(md5sum "$tar_path" | awk '{print $1}')"
printf '%s  %s\n' "$payload_md5" "$tar_base" >> "$tar_path"
install -m 0644 "$tar_path" "$output_dir/$odin_name"

footer_size=$((32 + 2 + ${#tar_base} + 1))
archive_size="$(stat -c %s "$output_dir/$odin_name")"
payload_size=$((archive_size - footer_size))
recorded_md5="$(tail -c "$footer_size" "$output_dir/$odin_name" | cut -c 1-32)"
head -c "$payload_size" "$output_dir/$odin_name" > "$build_dir/check/payload.tar"
actual_md5="$(md5sum "$build_dir/check/payload.tar" | awk '{print $1}')"
[[ "$recorded_md5" == "$actual_md5" && "$actual_md5" == "$payload_md5" ]]

tar -xf "$build_dir/check/payload.tar" -C "$build_dir/check" boot.img.lz4
lz4 -t "$build_dir/check/boot.img.lz4" >/dev/null
[[ "$(lz4 -dc "$build_dir/check/boot.img.lz4" | sha256sum | awk '{print $1}')" == "$expected_boot_sha" ]]

(
  cd "$output_dir"
  sha256sum "$boot_name" "$odin_name" "$apk_name" "$instructions_name" > "$sums_name"
  sha256sum -c "$sums_name"
)

echo "Built and verified incremental v1.0.2 assets:"
stat -c '%s  %n' "$output_dir/$boot_name" "$output_dir/$odin_name" \
  "$output_dir/$apk_name" "$output_dir/$instructions_name" "$output_dir/$sums_name"
