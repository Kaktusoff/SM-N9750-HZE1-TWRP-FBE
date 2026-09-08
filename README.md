# SM-N9750 HZE1: TWRP FBE + Magisk Alpha — v1.0.1 base + v1.0.2 BOOT update

**[Русский](README_RU.md)** · [English](README.md)

A unified, physical-device-tested package for the Snapdragon Samsung Galaxy
Note10+ `SM-N9750` on the exact stock base `N9750ZSU6HZE1` (Android 12).

This is not a custom ROM. Stock One UI stays installed and the package changes
only `BOOT` and `RECOVERY`. The first Samsung bootloader unlock still wipes all
user data and permanently trips Knox.

## Latest update: v1.0.2

v1.0.2 is an incremental, no-wipe BOOT-only update for an exact HZE1 phone
that already has the v1.0.1 TWRP+Alpha package. It upgrades the embedded core
to Magisk Alpha `96221b69-alpha (31000)` while retaining the tested TWRP-
survival overlay. Installing the 31000 APK alone updates only the manager app;
it does not replace the core in BOOT.

The v1.0.2 BOOT passed physical-device read-back and a complete Android → TWRP
→ Android cycle. See [UPDATE_ALPHA_31000.md](UPDATE_ALPHA_31000.md) for the
scope, exact checksums, and Odin/Heimdall instructions. The complete v1.0.1
package remains the required base for a fresh installation.

## Why v1.0.1 exists

The originally published v1.0.0/v1.0.1 payloads used official Magisk 30.7.
Root, TWRP and Play Integrity worked, but T-Pay still detected the rooted
environment and reported that the service was unavailable. On the same phone,
T-Pay started working after switching to Magisk Alpha
`e8a58776-alpha (30700)`, and a card was added successfully.

The new BOOT combines that tested Alpha boot with `twrp-survival.rc`, which
stops Samsung's `vendor_flash_recovery` service and prevents stock recovery
from replacing TWRP. The existing v1.0.1 contents were replaced in place and
v1.0.0 was withdrawn so users do not have to choose between conflicting
instructions.

## Verified on physical hardware

- normal Android boot without a key combination;
- Magisk Alpha `e8a58776-alpha (30700)` and working `su`;
- TWRP `3.7.1_12-HZE1-FBE-lab-13`;
- `/data` decryption with the existing Android PIN/password;
- the complete SID-validated synthetic-password / Gatekeeper / Keymaster flow;
- TWRP persistence after normal Android boot;
- a complete Android → TWRP → Android reboot cycle;
- byte-for-byte BOOT and RECOVERY read-back from the phone;
- YouTube ReVanced Extended `20.51.39` and YouTube Music ReVanced Extended
  `9.15.51` enabled and launch-tested;
- the known-good banking profile produced three green Play Integrity verdicts,
  enabled T-Pay, and accepted a card;
- after removing one separate filesystem trigger, T-Bank `8.2.2` again offered
  fingerprint sign-in while T-Pay and the provisioned card remained intact.

## Important after using TWRP with T-Bank

T-Bank `8.2.2` treats the mere presence of
`/storage/emulated/0/TWRP` (`/sdcard/TWRP`) as a modified-environment signal,
even when the directory is empty. This can remove fingerprint sign-in while
all Play Integrity verdicts remain green and T-Pay still works.

Before opening T-Bank after a recovery session, force-stop the app and move the
whole directory into `RecoveryBackups`; do not delete backups. Use
`scripts/fix-tbank-biometric.sh` on Linux/macOS or
`scripts/fix-tbank-biometric.ps1` on Windows. TWRP can recreate the directory,
so check it after every recovery boot. Keep **Enforce DenyList enabled**, keep
T-Bank in DenyList, use Magisk's built-in Zygisk, and keep Shamiko and Zygisk
Next disabled for the reference profile. This fix does not require clearing or
reinstalling the banking app.

The confirmed profile also uses Magisk's **Hide the Magisk app** function with
a neutral random manager package. The exact package name is intentionally not
published. See the post-install guide for the exact Tricky Store targets and
keybox verification/fallback.

## Exact compatibility

| Item | Required value |
|---|---|
| Model | `SM-N9750` |
| Device | `d2q`, Snapdragon |
| Base | `N9750ZSU6HZE1` |
| Android | 12 / API 31 |
| BOOT | 67,108,864 bytes |
| RECOVERY | 82,792,448 bytes |

Do not flash on `SM-N975F`, `SM-N976B`, `d2s`, `d2x`, another bootloader
revision, or another base firmware.

## Main v1.0.1 files

| File | Purpose | SHA-256 |
|---|---|---|
| `SM-N9750-HZE1-Magisk-Alpha-30700-BOOT-v1.0.1.img` | Alpha normal boot + TWRP survival | `027447589dc1845d65d6018df5322d54b01410e939a441e0fdcf63ae9c12a8c5` |
| `SM-N9750-HZE1-TWRP-3.7.1_12-FBE-v1.0.1.img` | TWRP with working FBE | `d8b050f0d342abde7339a95c5a255098a004399ff1ec78d33b0b151cf2967415` |
| `root-tools/Magisk-Alpha-e8a58776-30700.apk` | Exact manager APK for the tested BOOT | `e3cd39e1b8cef250841fa42b6a42d049c1b2f283cc93f55ecc90f1307c981d0b` |

See [INSTALL.md](INSTALL.md) for flashing, [POST_INSTALL_ROOT.md](POST_INSTALL_ROOT.md)
for the banking profile, Integrity Box/PIF order, DenyList, fingerprint fix,
and YouTube,
[UPDATE_ALPHA_31000.md](UPDATE_ALPHA_31000.md) for the v1.0.2 BOOT-only update,
[BUILD_AUDIT.md](BUILD_AUDIT.md) for verification, and
[CHANGELOG.md](CHANGELOG.md) for changes.

## Scope of the banking result

BOOT and RECOVERY are reproducible and verified by partition read-back. Banking
apps and Play Integrity use server-side rules that can change without a local
update. The release therefore does not embed a shared `keybox.xml`, a fixed
fingerprint, Magisk/banking-app data, or modified Google APKs. Those items are
revocable, privacy-sensitive, and would turn a maintainable package into a
short-lived one.

## Support the project

- Visa T-Bank: `4377 7278 0483 9954`
- USDT on TON: `UQAT_xqILzlNaVgnkqqpHC2v5MouL6jdhZArOAmE6TeJjo3R`

Verify the `TON` network and the complete address before sending.
