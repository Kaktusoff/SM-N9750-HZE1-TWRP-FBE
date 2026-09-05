# Known-good root and banking profile for v1.0.1

This documents the actual reference-phone configuration, not a recommendation
to enable every available hiding module. Reducing active hooks was part of
making T-Pay work.

## Confirmed state on September 5, 2026

- Magisk Alpha `e8a58776-alpha`, version code `30700`;
- built-in Zygisk enabled;
- DenyList enabled;
- Play Integrity Fork `v18` and Tricky Store `v1.4.1` active;
- the phone on which T-Pay worked and accepted a card used Tricky Store build
  `248-3b07ee3`;
- Shamiko `1.2.5`, Vector `2.2`, and Zygisk Next `1.2.9.1` installed but
  disabled;
- HMA `3.8.3` installed but not hooking applications while Vector is disabled;
- three green Play Integrity verdicts;
- T-Pay became available after replacing official Magisk 30.7 with Alpha;
- T-Bank `8.2.2` was verified with T-Pay, a provisioned card, and fingerprint
  sign-in together after removing the `/sdcard/TWRP` directory trigger.

The official public Tricky Store upstream offered `v1.4.1 build 245` when this
release was prepared. Obtain it from the author. This project does not
redistribute the closed build 248 binary.

## Why the extra modules are not enabled

Shamiko, Zygisk Next, Vector, and HMA are useful for other applications, but
each introduces another runtime hook and another observable signal. The
reference phone did not require them for T-Pay. v1.0.1 therefore defaults to a
bank-first profile: Alpha + built-in Zygisk + PIF + Tricky Store.

Integrity Box v41 and Play Integrity Fork v18 both use the module id
`playintegrityfix`, so they cannot remain active together. Integrity Box may be
used temporarily to refresh keybox/fingerprint material. Do not uninstall it
before changing to PIF: this exact Integrity Box uninstall script deletes
Tricky Store's `keybox.xml` and `target.txt`. Install PIF v18 directly over the
same module id after preserving the final Tricky Store configuration.

## Setup order

1. Install `Magisk-Alpha-e8a58776-30700.apk` from the release. If upgrading
   from the old official 30.7 package, open Alpha and confirm working root,
   then remove only the legacy manager APK with
   `adb uninstall com.topjohnwu.magisk`. If it was hidden, restore the old app
   name first or uninstall the exact old app from Android App info. Never guess
   its randomized package and never choose complete Magisk/root removal.
2. In Alpha, use **Hide the Magisk app**, give the repackaged manager a neutral
   random name/package, and do not publish the generated package name. Then
   enable built-in Zygisk and **Enforce DenyList**, and reboot.
3. Install Tricky Store only from its
   [official upstream](https://github.com/5ec1cff/TrickyStore/releases/tag/1.4.1).
4. If a keybox refresh is required, first stop if another attestation stack has
   external OMK or TEE Simulator configuration:

   ```bash
   adb shell su -c 'if [ -d /data/misc/keystore/omk ] || [ -d /data/adb/teesim ] || [ -d /data/adb/tricky_store/persistent_keys ]; then echo EXTERNAL_OR_PERSISTENT_ATTESTATION_STATE_PRESENT_ABORT_INSTALL_OR_ACTION; exit 76; else echo OK_NO_EXTERNAL_ATTESTATION_STATE; fi'
   ```

   The Integrity Box installer and Action both invoke its key updater. It
   rewrites OMK/TEE Simulator files and deletes/recreates `persistent_keys`
   when those locations are present, while its transition cleanup does not
   restore them. Their ownership, SELinux context, and rollback format are
   module-specific, so this guide does not attempt an unsafe generic restore.
   If the check aborts, stop and use the corresponding attestation module
   maintainer's own backup/restore procedure before continuing.

   Then preserve the existing Tricky Store files **before installing or
   running Integrity Box** in a private root-only directory:

   ```bash
   adb shell su -c 'set -e; r=/data/adb/tricky_store; d="$r/private-backups"; mkdir -p "$d"; chmod 0700 "$d"; t=$(date +%Y%m%d-%H%M%S); for f in keybox.xml target.txt security_patch.txt; do s="$r/$f"; if [ -e "$s" ]; then b="$d/$f.pre-integrity-box.$t"; [ ! -e "$b" ]; cp -p "$s" "$b"; cmp -s "$s" "$b"; fi; done; echo PRE_ACTION_BACKUP_OK_$t'
   ```

   The Integrity Box installer and Action are not keybox-only operations: they
   clear Tricky Store key caches and can rewrite the fingerprint, `target.txt`,
   `security_patch.txt`, system security-patch properties, and OMK/TEE
   Simulator configuration.
5. Establish stable Internet and decide that you trust the publisher's current
   endpoint **before installing** Integrity Box v41: the installer immediately
   invokes the same network key updater and may mutate the files above. The
   installer does not fail closed if that helper fails, so “Installation
   Completed” is not proof of a keybox update. Reboot and verify that `name=` in
   `/data/adb/modules/playintegrityfix/module.prop` now identifies Integrity
   Box. If a refresh is still needed, run Action once only after Integrity Box
   is confirmed active and Internet is stable.
6. v41 does not contain a keybox. Both its installer and Action fetch a mutable
   encoded payload from the publisher, back up the old file under
   `/data/adb/Box-Brain/KeyBackup`, and attempt to write the decoded result
   directly to `/data/adb/tricky_store/keybox.xml`. The release ZIP checksum
   does not authenticate that later network payload. v41 also disables TLS
   certificate verification for these downloads and validates only that the
   decoded output is non-empty, not its XML/certificate structure, signature,
   freshness, or revocation state. Run this only if you trust the publisher and
   its current endpoint.
7. Verify the most recent installer/Action updater run instead of trusting its
   completion screen:

   ```bash
   adb shell su -c 'grep -E "^(name|version)=" /data/adb/modules/playintegrityfix/module.prop'
   adb shell su -c 'tail -n 30 /data/adb/Box-Brain/Integrity-Box-Logs/keybox.log | grep -E "Keybox successfully updated|ERROR:"'
   adb shell su -c 'if [ -s /data/adb/tricky_store/keybox.xml ]; then ls -ln /data/adb/tricky_store/keybox.xml; else echo MISSING_OR_EMPTY; fi'
   ```

   A success line and non-empty file prove only that the updater ran, not that
   the keybox is valid, unrevoked, or accepted by Google. The Strong/Device
   badge in Integrity Box WebUI comes from a separate remote status file and
   does not validate the local keybox. On the reference phone, the automatic
   updater did not leave Tricky Store with the required current file, so the
   freshly obtained file was backed up and copied to that exact destination
   manually.
8. Reapply the exact Tricky Store targets below after the installer/Action,
   because either path can overwrite `target.txt`. Preserve the final
   `keybox.xml`, `target.txt`, and `security_patch.txt` under a unique name in a
   private root-only directory outside `/data/adb/Box-Brain`.
9. Install PIF v18 directly over Integrity Box without uninstalling Integrity
   Box first. Before reboot, run this fail-closed check: it removes an inherited
   Integrity Box uninstall script only when the staged module is exactly PIF
   v18 by name/version and the script has Integrity Box's signature. Missing/mismatched
   state aborts instead of silently continuing:

   ```bash
   adb shell su -c 'set -e; p=/data/adb/modules_update/playintegrityfix; [ -f "$p/module.prop" ] || { echo MISSING_STAGED_PIF_ABORT >&2; exit 71; }; grep -q "^name=Play Integrity Fork$" "$p/module.prop" && grep -q "^version=v18$" "$p/module.prop" && grep -q "^versionCode=180000$" "$p/module.prop" || { echo NOT_EXACT_STAGED_PIF_V18_ABORT >&2; exit 72; }; u="$p/uninstall.sh"; if [ -e "$u" ]; then if grep -q "Integrity-Box Uninstall Started" "$u"; then rm -f "$u"; else echo UNKNOWN_UNINSTALLER_ABORT >&2; exit 73; fi; fi; [ ! -e "$u" ] || { echo UNINSTALLER_REMOVE_FAILED_ABORT >&2; exit 74; }; echo STAGED_PIF_V18_UNINSTALLER_SAFE'
   ```

   Do not reboot unless this prints `STAGED_PIF_V18_UNINSTALLER_SAFE` and exits
   successfully. This exact PIF installer otherwise copies the old module's
   `uninstall.sh`; a later PIF removal could delete Tricky Store's keybox and
   targets. After reboot, verify active PIF v18, confirm the Tricky Store files
   still exist, and fail if any uninstall script survived:

   ```bash
   adb shell su -c 'set -e; p=/data/adb/modules/playintegrityfix; grep -q "^name=Play Integrity Fork$" "$p/module.prop" && grep -q "^version=v18$" "$p/module.prop" && grep -q "^versionCode=180000$" "$p/module.prop" || { echo ACTIVE_MODULE_IS_NOT_EXACT_PIF_V18_ABORT >&2; exit 75; }; [ -s /data/adb/tricky_store/keybox.xml ] || { echo KEYBOX_MISSING_ABORT >&2; exit 76; }; [ -s /data/adb/tricky_store/target.txt ] || { echo TARGETS_MISSING_ABORT >&2; exit 77; }; [ ! -e "$p/uninstall.sh" ] || { echo UNSAFE_OR_UNKNOWN_UNINSTALLER_ABORT >&2; exit 78; }; echo OK_ACTIVE_PIF_V18_NO_UNINSTALLER'
   ```
10. Do not copy a shared keybox/fingerprint from this guide. Current material is
    private and can be revoked remotely. Do not enable Integrity Box's Export
    Keybox option unless necessary: it creates `/sdcard/keybox.xml` in shared
    storage.

If manual replacement is necessary and the fresh trusted file is already on
your own computer, keep the old file outside `Box-Brain` and install only that
known file:

```bash
adb push /path/to/current-keybox.xml /data/local/tmp/current-keybox.xml
adb shell su -c 'set -e; s=/data/local/tmp/current-keybox.xml; k=/data/adb/tricky_store/keybox.xml; [ -s "$s" ]; d=/data/adb/tricky_store/private-backups; mkdir -p "$d"; chmod 0700 "$d"; t=$(date +%Y%m%d-%H%M%S); b="$d/keybox-manual-before.$t.xml"; [ ! -e "$b" ]; if [ -e "$k" ]; then cp -p "$k" "$b"; cmp -s "$k" "$b"; fi; cp -f "$s" "$k"; chown 0:0 "$k"; chmod 0600 "$k"; cmp -s "$s" "$k"; sync; rm -f "$s"'
```

Verify that the destination exists and is non-empty, then reboot. Do not paste,
upload, or attach the keybox itself to an issue or forum post.

Minimal Tricky Store targets:

```text
com.google.android.gms!
com.google.android.gsf
com.android.vending
com.idamob.tinkoff.android!
io.github.vvb2060.keyattestation!
```

`!` forces generate-certificate mode. The three suffixed entries above are the
exact reference-phone target configuration; do not add `!` to every package.

To replace an Action-generated list with that exact tested set, use this
backup-first atomic write. It verifies the temporary copy and the installed
file byte-for-byte; any failed step returns nonzero:

```bash
adb shell su -c 'set -e; r=/data/adb/tricky_store; d="$r/private-backups"; mkdir -p "$d"; chmod 0700 "$d"; o="$r/target.txt"; t=$(date +%Y%m%d-%H%M%S); if [ -e "$o" ]; then b="$d/target.before-tested-set.$t.txt"; [ ! -e "$b" ]; cp -p "$o" "$b"; cmp -s "$o" "$b"; fi; n="$r/.target.new.$$"; v="$r/.target.verify.$$"; trap "rm -f \"$n\" \"$v\"" 0 1 2 3 15; printf "%s\n" "com.google.android.gms!" "com.google.android.gsf" "com.android.vending" "com.idamob.tinkoff.android!" "io.github.vvb2060.keyattestation!" > "$n"; [ "$(wc -l < "$n")" -eq 5 ]; cp -p "$n" "$v"; cmp -s "$n" "$v"; chown 0:0 "$n"; chmod 0600 "$n"; mv -f "$n" "$o"; cmp -s "$o" "$v"; echo TARGETS_ATOMIC_WRITE_OK'
```

Before installing PIF over Integrity Box, preserve the final Tricky Store
files outside `Box-Brain` (the transition cleanup removes `Box-Brain`):

```bash
adb shell su -c 'set -e; r=/data/adb/tricky_store; [ -s "$r/keybox.xml" ]; [ -s "$r/target.txt" ]; d="$r/private-backups"; mkdir -p "$d"; chmod 0700 "$d"; t=$(date +%Y%m%d-%H%M%S); for f in keybox.xml target.txt security_patch.txt; do s="$r/$f"; if [ -e "$s" ]; then b="$d/$f.$t"; [ ! -e "$b" ]; cp -p "$s" "$b"; cmp -s "$s" "$b"; fi; done'
```

Minimal DenyList from the reference profile:

```text
com.idamob.tinkoff.android | com.idamob.tinkoff.android
com.google.android.gsf | com.google.android.gsf
isolated | com.android.vending:isolated_service:com.google.android.finsky.verifier.apkanalysis.service.ApkContentsScanService
isolated | com.google.android.gms:com.google.android.gms.chimera.IsolatedBoundBrokerService
```

For this profile, **Enforce DenyList must remain enabled** and
`com.idamob.tinkoff.android` must remain listed. Shamiko is disabled. In the
tested Shamiko mode the banking app could additionally see
`/system_ext/bin/su`, so replacing Enforce DenyList with Shamiko did not solve
the problem.

Never add an app that needs root. Adding `be.mygod.vpnhotspot`, for example,
makes VPN Hotspot report `Root is missing` even when its Magisk policy is
`ALLOW`.

If T-Pay and cards already work, **do not clear or reinstall T-Bank**. Doing so
removes the local sign-in and may require payment-token provisioning again.
This guide does not use bank-app clearing as a troubleshooting step. Clearing
Google Play Store data belongs only to separate Play Integrity troubleshooting
and is not permission to clear T-Bank.

## Why fingerprint sign-in can disappear

T-Bank `8.2.2` has a MIAF check for
`/storage/emulated/0/TWRP` (`/sdcard/TWRP`). Even an empty directory is enough:
T-Pay may keep working while the biometric-sign-in option disappears. On the
reference phone the directory was renamed without clearing bank data, after
which the user confirmed both T-Pay and fingerprint sign-in working together.

TWRP can recreate that directory. After every recovery session and before the
first bank-app launch, run one of the included helpers:

```bash
./scripts/fix-tbank-biometric.sh
```

```powershell
.\scripts\fix-tbank-biometric.ps1
```

The helpers require current Android Platform Tools. Odin flashing itself does
not require USB debugging, but the helper does: boot Android, enable USB
debugging temporarily, connect the cable, unlock the phone, and accept that
computer's RSA authorization prompt. `adb devices` must show exactly one device
with state `device`, not `unauthorized`. If Windows execution policy blocks the
script, use a one-process bypass without changing the system policy:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\fix-tbank-biometric.ps1
```

The helper does not delete backups. It force-stops only T-Bank and moves the
whole directory to a unique
`/sdcard/RecoveryBackups/TWRP-YYYYMMDD-HHMMSS` path. To do it manually:

```bash
adb shell am force-stop com.idamob.tinkoff.android
adb shell mkdir -p /sdcard/RecoveryBackups
adb shell mv /sdcard/TWRP /sdcard/RecoveryBackups/TWRP-manual
```

If `TWRP-manual` already exists, choose another name; never overwrite it. Move
a backup directory back temporarily when TWRP must restore it, then remove the
new `/sdcard/TWRP` path again after leaving recovery.

## YouTube and YouTube Music

The reference phone has these data apps enabled and launch-tested:

- YouTube ReVanced Extended `20.51.39`;
- YouTube Music ReVanced Extended `9.15.51`.

Their Magisk modules may stay disabled in the bank-first profile because the
apps remain installed in `/data`. This reduces system mount/hook traces without
removing the apps. Modified Google APKs are not redistributed; use the upstream
[MANCrimSon releases](https://github.com/MANCrimSon/YouTube-ReVanced-Extended/releases).

## Verify

```bash
adb shell su -c 'magisk -v'
adb shell su -c 'magisk -V'
adb shell su -c 'magisk --denylist ls'
adb shell su -c 'grep -E "^(name|version|versionCode)=" /data/adb/modules/playintegrityfix/module.prop'
adb shell su -c 'grep -E "^(name|version|versionCode)=" /data/adb/modules/tricky_store/module.prop'
```

Expected: Alpha `e8a58776`, code `30700`, PIF `v18`, Tricky Store `v1.4.1`,
with Zygisk and DenyList enabled. Green Play Integrity verdicts do not guarantee
one bank: T-Pay evaluates additional app-specific signals, including traces in
shared storage that the app can read.
