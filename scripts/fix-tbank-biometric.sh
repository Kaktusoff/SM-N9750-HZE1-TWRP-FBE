#!/usr/bin/env bash
set -Eeuo pipefail

package_name="com.idamob.tinkoff.android"
source_path="/sdcard/TWRP"
backup_root="/sdcard/RecoveryBackups"
adb_bin="${ADB:-adb}"

die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

remote_text() {
  local output
  output="$("$adb_bin" shell "$1")" || die "ADB command failed."
  output="${output//$'\r'/}"
  output="${output//$'\n'/}"
  printf '%s' "$output"
}

command -v "$adb_bin" >/dev/null 2>&1 || die "adb was not found. Install Android Platform Tools or set ADB to its path."

device_state="$("$adb_bin" get-state 2>/dev/null || true)"
device_state="${device_state//$'\r'/}"
device_state="${device_state//$'\n'/}"
[[ "$device_state" == "device" ]] || die "Exactly one authorized Android device must be connected (current state: ${device_state:-unavailable})."

printf 'Stopping only %s...\n' "$package_name"
"$adb_bin" shell am force-stop "$package_name" >/dev/null || die "Could not stop $package_name."

source_kind="$(remote_text "if [ -d '$source_path' ]; then printf directory; elif [ -e '$source_path' ]; then printf other; else printf absent; fi")"
case "$source_kind" in
  absent)
    printf '%s is absent; the known T-Bank biometric root trigger is already clear.\n' "$source_path"
    printf 'Open T-Bank manually and check biometric sign-in.\n'
    exit 0
    ;;
  directory)
    ;;
  other)
    die "$source_path exists but is not a directory; it was left untouched."
    ;;
  *)
    die "Could not determine the state of $source_path (response: ${source_kind:-empty})."
    ;;
esac

"$adb_bin" shell "mkdir -p '$backup_root' && [ -d '$backup_root' ]" >/dev/null || die "Could not create $backup_root."

destination=""
for _attempt in {1..20}; do
  timestamp="$(date '+%Y%m%d-%H%M%S')"
  candidate="$backup_root/TWRP-$timestamp"
  candidate_state="$(remote_text "if [ -e '$candidate' ]; then printf exists; else printf free; fi")"
  if [[ "$candidate_state" == "free" ]]; then
    destination="$candidate"
    break
  fi
  [[ "$candidate_state" == "exists" ]] || die "Could not check destination $candidate."
  sleep 1
done

[[ -n "$destination" ]] || die "Could not allocate a unique timestamped backup path. Nothing was moved."

"$adb_bin" shell "if [ -e '$destination' ]; then printf 'destination collision' >&2; exit 73; fi; mv -n '$source_path' '$destination'" \
  >/dev/null || die "Move failed. The source was not intentionally deleted or overwritten."

verification="$(remote_text "if [ ! -e '$source_path' ] && [ -d '$destination' ]; then printf ok; else printf failed; fi")"
[[ "$verification" == "ok" ]] || die "Post-move verification failed; inspect $source_path and $destination before continuing."

printf 'Done: moved the complete directory without deleting it:\n  %s\n  -> %s\n' "$source_path" "$destination"
printf 'Open T-Bank manually and check biometric sign-in. TWRP may recreate %s after recovery use; rerun this helper if needed.\n' "$source_path"
