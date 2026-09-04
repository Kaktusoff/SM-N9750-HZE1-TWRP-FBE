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
- SHA-256: `88439e04000aea03d7477c3f32e6b30fa95040f83c97b893a066b039592c529f`;
- exact source stock BOOT SHA-256:
  `6718aba700e9850f76117f9f2ee74f56de7bbcd12eb324b7443a6cfb5bcae209`;
- patched by the official Magisk 30.7 `boot_patch.sh`;
- `RECOVERYMODE=false`, `KEEPVERITY=true`, `KEEPFORCEENCRYPT=true`,
  `PATCHVBMETAFLAG=true`, `LEGACYSAR=true`, `PREINITDEVICE=cache`;
- kernel differs from stock by the expected seven Magisk patch bytes for
  Samsung defex and `skip_initramfs`/`want_initramfs`;
- embedded `overlay.d/twrp-survival.rc` stops the stock recovery reconstruction
  service before its `class main` start.

## Physical-device verification

| Test | Result |
|---|---|
| Exact firmware `N9750ZSU6HZE1` | PASS |
| Normal Android boot | PASS |
| `sys.boot_completed=1` | PASS |
| Magisk 30.7 daemon | PASS |
| `su -c id` in `u:r:magisk:s0` | PASS |
| TWRP lab13 boot | PASS |
| Existing PIN decrypts `/data` | PASS |
| CE Keymaster authorization | PASS |
| Recovery survives Android boot | PASS |
| BOOT read-back hash | PASS |
| RECOVERY read-back hash | PASS |

MTP transfer, destructive format operations, full backup/restore, other users,
and firmware versions other than HZE1 are not claimed as tested.

