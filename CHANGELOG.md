# Changelog

## v1.0.1 — fully replaced on 2026-09-05

The existing v1.0.1 release was replaced in place with the unified Alpha + TWRP
+ banking-profile package. No new release or tag was created. v1.0.0 is
withdrawn and removed from downloads.

- Replaced official Magisk 30.7 with physical-device-tested Magisk Alpha
  `e8a58776-alpha (30700)`. This change made T-Pay available and a card was
  added successfully.
- Added an in-place migration step that removes only the separate legacy
  `com.topjohnwu.magisk` manager APK after Alpha root is confirmed, including
  safe handling of an older randomized hidden manager. It never invokes full
  Magisk/root removal.
- Merged the Alpha ramdisk with `overlay.d/twrp-survival.rc`, which had been
  lost during the second BOOT patch. It stops `vendor_flash_recovery` during
  `early-init` and preserves TWRP.
- Flashed the new BOOT to the physical `SM-N9750` and verified normal Android
  boot, `su`, partition SHA-256 read-back, and a complete Android → TWRP →
  Android cycle.
- RECOVERY is the unchanged device-tested lab13 FBE binary under a v1.0.1 file
  name and the same SHA-256.
- Rebuilt Linux/Heimdall and Windows/Odin no-USERDATA/no-PIT packages.
- Preserved guarded `--flash-no-wipe` BOOT+RECOVERY and
  `--twrp-only-no-wipe` RECOVERY-only modes for an already-unlocked exact HZE1
  device. The first Samsung bootloader unlock still always wipes data.
- Added the exact Alpha manager APK, Integrity Box v41, and PIF v18. Tricky
  Store is downloaded from upstream and SHA-256 verified instead of rehosting
  a closed binary.
- Rewrote the banking guide around the actual known-good state: built-in
  Zygisk + DenyList + PIF v18 + Tricky Store. Shamiko, Vector, Zygisk Next, and
  HMA are not part of the default bank-first profile.
- Added the tested Magisk-manager hiding step and the exact Tricky Store target
  set, including forced generate-certificate mode for GMS, T-Bank, and Key
  Attestation.
- Documented that Integrity Box and PIF share the `playintegrityfix` module id
  and replace each other. Added verification of Integrity Box's keybox log and
  resulting `/data/adb/tricky_store/keybox.xml`, plus a backup-first manual
  fallback because Action did not complete that update on the reference phone.
- Added a verified pre-install/pre-Action Tricky Store backup and a fail-closed
  check for external OMK/TEE Simulator/persistent-key state, which both the
  Integrity Box installer and Action can rewrite but transition cleanup cannot
  restore safely.
- Documented the safe direct-overwrite transition to PIF v18 and removal of an
  inherited Integrity Box uninstaller that could otherwise delete Tricky Store
  keybox/target configuration during a later PIF removal.
- Re-enabled and launch-tested YouTube ReVanced Extended `20.51.39` and YouTube
  Music ReVanced Extended `9.15.51`; their Magisk modules may remain disabled
  while the data apps are installed.
- Identified a separate T-Bank 8.2.2 filesystem trigger: even an empty
  `/storage/emulated/0/TWRP` removed fingerprint sign-in. Moving the directory
  safely into `RecoveryBackups` without clearing bank data restored fingerprint
  sign-in while T-Pay remained operational.
- Added Linux/macOS and Windows ADB helpers that force-stop only T-Bank and move
  the TWRP directory under a unique name without deleting or overwriting
  backups. Documented Platform Tools, USB-debugging/RSA authorization, and a
  one-process Windows PowerShell policy bypass.
- Removed the previous recommendation to clear bank-app data after changing the
  profile; this is unnecessary when T-Pay works and can require card
  reprovisioning.

## v1.0.0 — 2026-09-04 (withdrawn)

First device-tested public release.

### Recovery and FBE

- Built TWRP 3.7.1_12 from pinned Android 12.1 sources for exact HZE1 recovery
  geometry and stock hardware payload.
- Added the missing two-stage Samsung/Qualcomm synthetic-password flow:
  - use the user-credential Gatekeeper HAT to open the synthetic-password blob;
  - derive the separate `sp-gk-authentication` credential;
  - verify the primary-user synthetic-password Gatekeeper handle;
  - capture and validate the second HAT against its Secure User ID;
  - authorize Keymaster CE-key decryption with the SID-matched HAT.
- Added Android 12 KeyMint/Keymaster compatibility handling used by HZE1.
- Removed the unavailable legacy `keystore_auth` path while preserving HZE1
  `keystore2`, Gatekeeper, Keymaster and qseecomd services.
- Added recovery HIDL dependencies required by the Qualcomm QSEECom payload.
- Confirmed real-device decryption of user 0 `/data` with the existing Android
  credential.

### Normal boot and recovery persistence

- Patched the exact live HZE1 BOOT with official Magisk 30.7 scripts.
- Uses normal boot: `RECOVERYMODE=false`, `LEGACYSAR=true`,
  `PREINITDEVICE=cache`, `KEEPVERITY=true`, `KEEPFORCEENCRYPT=true`.
- Preserves the stock BOOT geometry and embedded vbmeta descriptor; Magisk sets
  AVB flags 3 for the unlocked-bootloader path.
- Added `overlay.d/twrp-survival.rc`, which stops Samsung's
  `vendor_flash_recovery` service at early init without modifying `/vendor`.
- Confirmed normal Android boot, working `su`, and persistent lab13 recovery.

### Verification

- BOOT partition read-back SHA-256 matches the release image.
- RECOVERY partition read-back SHA-256 matches the release image after normal
  Android boot.
- TWRP was booted again after Android and still reported lab13.
