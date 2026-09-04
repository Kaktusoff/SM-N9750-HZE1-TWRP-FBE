# Changelog

## v1.0.1 — 2026-09-04

Installer and documentation update; binary images are unchanged from v1.0.0.

- Added guarded `--flash-no-wipe` mode for the tested BOOT+RECOVERY pair on an
  already-unlocked exact HZE1 device.
- Added `--twrp-only-no-wipe` mode, which flashes RECOVERY without touching BOOT
  or USERDATA.
- Documented that the first Samsung bootloader unlock always wipes data and
  that stock BOOT can restore stock recovery after a recovery-only install.

## v1.0.0 — 2026-09-04

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
