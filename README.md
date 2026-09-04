# Samsung Galaxy Note10+ SM-N9750 HZE1: TWRP FBE + Magisk

**[Русская версия](README_RU.md)** · [English](README.md)

Unofficial, device-tested TWRP 3.7.1_12 and Magisk 30.7 boot images for the
Snapdragon Samsung Galaxy Note10+ `SM-N9750` running the exact stock firmware
`N9750ZSU6HZE1` (Android 12).

This is not a custom ROM. It keeps the stock HZE1 system and replaces only the
`BOOT` and `RECOVERY` partitions.

## Status

Release `v1.0.1` uses the same device-tested images as v1.0.0 and adds explicit
guarded no-wipe installation modes:

- Android HZE1 boots normally without a special key combination;
- Magisk 30.7 and `su` work from the normal boot path;
- TWRP boots as `3.7.1_12-HZE1-FBE-lab-13`;
- the existing Android PIN unlocks and decrypts `/data` in TWRP;
- primary-user CE storage is decrypted through a SID-validated synthetic-password HAT;
- the custom recovery survives a normal Android boot;
- BOOT and RECOVERY read-back hashes match the published images.
- `--flash-no-wipe` flashes the tested BOOT+RECOVERY pair without touching
  `USERDATA` when the bootloader is already unlocked;
- `--twrp-only-no-wipe` flashes RECOVERY only, with a clear warning that stock
  BOOT may restore stock recovery after Android starts.

## Exact compatibility

| Item | Required value |
|---|---|
| Model | `SM-N9750` |
| Device | `d2q` / Snapdragon |
| Base firmware | `N9750ZSU6HZE1` |
| Android | 12 / API 31 |
| BOOT partition size | 67,108,864 bytes |
| RECOVERY partition size | 82,792,448 bytes |

Do not flash these images on `SM-N975F`, `SM-N976B`, `d2s`, `d2x`, another
bootloader revision, or another firmware build.

## Release files

| Asset | Purpose | SHA-256 |
|---|---|---|
| `SM-N9750-HZE1-Magisk-v30.7-BOOT-v1.0.0.img` | Normal Android boot with Magisk and recovery-survival rule | `88439e04000aea03d7477c3f32e6b30fa95040f83c97b893a066b039592c529f` |
| `SM-N9750-HZE1-TWRP-3.7.1_12-FBE-v1.0.0.img` | TWRP with working HZE1 FBE decryption | `d8b050f0d342abde7339a95c5a255098a004399ff1ec78d33b0b151cf2967415` |
| `device-samsung-d2q-HZE1-lab13.tar.zst` | Reproducible device tree snapshot | `6108eed3507fba747aa50ce415e447fa7cd138d779da29cb9b81f6ff7f74b888` |

See [INSTALL.md](INSTALL.md) for the complete stock-to-custom procedure,
[INSTALL_RU.md](INSTALL_RU.md) for Russian instructions, and
[BUILD_AUDIT.md](BUILD_AUDIT.md) for the technical verification record.

Changelog: [English](CHANGELOG.md) · [Русский](CHANGELOG_RU.md). Root stack:
[English](POST_INSTALL_ROOT.md) · [Русский](POST_INSTALL_ROOT_RU.md).

## Important warning

Unlocking the Samsung bootloader wipes user data and permanently trips Knox.
Once the bootloader is already unlocked, flashing the exact published BOOT and
RECOVERY images does not itself wipe `USERDATA`.
Samsung Pay, Secure Folder and other Knox-backed functions may never work again,
even after returning to stock. Flashing the wrong model or firmware can leave the
device unable to boot. Make an offline backup before starting.

## Optional tested root stack

The images do not bundle third-party modules or proprietary patched Google APKs.
The following combination was tested on the reference phone:

- Integrity Box v41 plus Tricky Store v1.4.1 (248);
- Shamiko v1.2.5 (414), blacklist mode;
- Vector v2.2 (3080), with HMA 3.8.3 enabled;
- YouTube ReVanced Extended 20.51.39;
- YouTube Music ReVanced Extended 9.15.51.

Use only upstream releases. See [POST_INSTALL_ROOT.md](POST_INSTALL_ROOT.md).
Integrity verdicts and application root-detection behavior can change remotely
and are not guaranteed by this project.

## Credits

- [TeamWin Recovery Project](https://github.com/TeamWin/android_bootable_recovery)
- [Magisk](https://github.com/topjohnwu/Magisk)
- the upstream projects linked in [POST_INSTALL_ROOT.md](POST_INSTALL_ROOT.md)

## Support the project

- Visa T-Bank: `4377 7278 0483 9954`
- USDT on TON: `UQAT_xqILzlNaVgnkqqpHC2v5MouL6jdhZArOAmE6TeJjo3R`

Verify the TON network and the complete address before sending. See
[DONATE.md](DONATE.md).
