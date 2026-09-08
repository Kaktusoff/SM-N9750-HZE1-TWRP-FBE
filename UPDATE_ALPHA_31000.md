# Incremental Magisk Alpha 31000 BOOT update — v1.0.2

This update is only for an already-unlocked Snapdragon Galaxy Note10+
`SM-N9750` / `d2q` running the exact `N9750ZSU6HZE1` Android 12 base with the
v1.0.1 TWRP+Alpha package installed.

Installing the Alpha 31000 APK updates the manager application, but it does not
replace the Magisk core embedded in `BOOT`. The v1.0.2 image upgrades that core
from `e8a58776-alpha (30700)` to `96221b69-alpha (31000)` while retaining the
same `overlay.d/twrp-survival.rc` rule that prevents Samsung
`vendor_flash_recovery` from replacing TWRP.

This is a BOOT-only, no-wipe update. It contains no `RECOVERY`, `USERDATA`,
`PIT`, `BL`, `CP`, `CSC`, or `SUPER` payload.

## Files

| File | SHA-256 |
|---|---|
| `SM-N9750-HZE1-Magisk-Alpha-31000-BOOT-v1.0.2.img` | `3e0bf40a2e4d64dce1924d37c7e06a1fb3777079d7b1ce027563ad483240f8c4` |
| `AP_SM-N9750_HZE1_Magisk-Alpha-31000-BOOT-only_v1.0.2.tar.md5` | `28019d0c876fb50944aedac2d27efa5917665d39adb205b35350176537e95469` |
| `Magisk-Alpha-96221b69-31000.apk` | `f77216f829cd0185f58e4b87526544891cca562b8e71a7730856871c24265300` |

The APK is signed by the same `CN=vvb2060` signer as the v1.0.1 Alpha 30700
APK. Its signing-certificate SHA-256 fingerprint is:

```text
59:C2:3D:1C:00:72:8B:02:84:D6:A4:6D:41:14:61:8C:20:D3:54:CB:17:DD:74:3B:AA:76:44:E5:41:BC:1E:44
```

## Windows / Odin 3.14.4

1. Verify the download against `SHA256SUMS-v1.0.2.txt`.
2. Enter Download Mode and wait for Odin to show `ID:COM` / `Added!!`.
3. Put the `AP_...BOOT-only_v1.0.2.tar.md5` file in **AP**. Leave **BL**,
   **CP**, **CSC**, and **USERDATA** empty.
4. Do not enable **Re-Partition**, **Nand Erase All**, or **Flash Lock**, and do
   not select a PIT. **F. Reset Time** and **Auto Reboot** may remain enabled.
5. Start, wait for `PASS`, and let Android boot. Open the Alpha manager and
   confirm core `96221b69-alpha (31000)`.

## Linux / Heimdall

From Download Mode, flash only the raw BOOT image:

```bash
heimdall flash --BOOT SM-N9750-HZE1-Magisk-Alpha-31000-BOOT-v1.0.2.img
```

## Physical-device verification

The final image was flashed to the reference `SM-N9750` and read back
byte-for-byte. Android completed boot, user 0 unlocked and CE data was readable,
`su` ran in `u:r:magisk:s0`, the core reported `96221b69-alpha (31000)`, and
DenyList remained enforced. The phone then completed an Android → TWRP →
Android cycle; TWRP still reported `3.7.1_12-HZE1-FBE-lab-13`, RECOVERY stayed
at SHA-256 `d8b050f0d342abde7339a95c5a255098a004399ff1ec78d33b0b151cf2967415`,
and `vendor_flash_recovery` remained stopped after returning to Android.

Play Integrity and banking-app decisions are server-side and were not re-tested
as part of this core-only update. The v1.0.1 banking result is not presented as
a permanent property of v1.0.2.

Never relock the bootloader while custom BOOT or RECOVERY is installed. Do not
flash this update on `SM-N975F`, `SM-N976B`, `d2s`, `d2x`, another bootloader
revision, or another firmware base.
