# Build and runtime audit

## Source baselines

| Project | Revision |
|---|---|
| `bootable/recovery` | `5c3d206a5eeb3d446bcda8248a405a4b278bab5c` |
| `system/vold` | `a164ba05c5fef288059774a776b2e6e1119957cf` |
| `system/libhidl` | `04ba2ded0f31a9aabc8113ca24b712375225e742` |
| `device/qcom/twrp-common` | `98506f7919102378c8d52ee7d6a94a867f1b4c55` |

The complete resolved manifest is in `source/pinned-base-manifest.xml`. Local
changes are stored as patches in `source/patches/`. The release assets include
the exact `device/samsung/d2q` snapshot used for the build.

## Recovery image

- size: `82,792,448` bytes;
- SHA-256: `d8b050f0d342abde7339a95c5a255098a004399ff1ec78d33b0b151cf2967415`;
- runtime version: `3.7.1_12-HZE1-FBE-lab-13`;
- stock HZE1 kernel, kernel DTB and recovery DTBO retained;
- ramdisk compressed with LZMA to fit exact partition geometry.

Successful runtime markers:

```text
Derived separate synthetic-password Gatekeeper credential for CE authorization
Primary-user synthetic-password HAT captured and SID-validated: 69 bytes
Authenticated Keymaster CE key decryption succeeded
User 0 Decrypted Successfully!
```

## Boot image

- size: `67,108,864` bytes;
- v1.0.1 SHA-256: `027447589dc1845d65d6018df5322d54b01410e939a441e0fdcf63ae9c12a8c5`;
- device-read Alpha input SHA-256:
  `9dd7c4f948bf9f314f111ea42b5abd9641931b0f9282c33e031d3854bb7baf00`;
- exact source stock BOOT SHA-256:
  `6718aba700e9850f76117f9f2ee74f56de7bbcd12eb324b7443a6cfb5bcae209`;
- patched with Magisk Alpha `e8a58776-alpha (30700)`;
- `.backup/.magisk` contains `RECOVERYMODE=false`, `VENDORBOOT=false`,
  `KEEPVERITY=true`, `KEEPFORCEENCRYPT=true`, and `PREINITDEVICE=cache`;
- kernel differs from stock by the expected seven Magisk patch bytes for
  Samsung defex and `skip_initramfs`/`want_initramfs`;
- embedded `overlay.d/twrp-survival.rc` stops the stock recovery reconstruction
  service before its `class main` start;
- the deterministic merge is implemented by
  `scripts/build-alpha-survival-boot.sh`.

## Physical-device verification

| Test | Result |
|---|---|
| Exact firmware `N9750ZSU6HZE1` | PASS |
| Normal Android boot | PASS |
| `sys.boot_completed=1` | PASS |
| Magisk Alpha `e8a58776` / 30700 daemon | PASS |
| `su -c id` in `u:r:magisk:s0` | PASS |
| TWRP lab13 boot | PASS |
| Existing PIN decrypts `/data` | PASS |
| CE Keymaster authorization | PASS |
| Recovery survives Android boot | PASS |
| Android → TWRP → Android cycle | PASS |
| BOOT read-back SHA-256 `027447…a8c5` | PASS |
| RECOVERY read-back SHA-256 `d8b050…7415` | PASS |
| Three Play Integrity verdicts | PASS on 2026-09-05 |
| T-Pay with provisioned card | PASS on 2026-09-05 |
| T-Bank 8.2.2 fingerprint sign-in | PASS after removing `/sdcard/TWRP` |

The banking result was obtained on the same phone with the same Alpha core and
unchanged `/data/adb` configuration before adding the recovery-survival rc.
That result included three green Play Integrity verdicts, T-Pay availability,
and a successfully added card. A separate T-Bank 8.2.2 MIAF path check matched
`/storage/emulated/0/TWRP`; even the empty directory removed the biometric
option. Moving it intact to `RecoveryBackups` without clearing app data restored
fingerprint sign-in while T-Pay remained operational. App-side/server-side
verdicts are not immutable and are not treated as a permanent image property.

MTP transfer, destructive format operations, full backup/restore, other users,
and firmware versions other than HZE1 are not claimed as tested.
