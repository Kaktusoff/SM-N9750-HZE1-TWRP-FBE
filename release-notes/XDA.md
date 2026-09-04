[SIZE=6][B]TWRP 3.7.1_12 FBE + Magisk 30.7 for SM-N9750 HZE1 — v1.0.1[/B][/SIZE]

[B]Device:[/B] Samsung Galaxy Note10+ Snapdragon, SM-N9750 / d2q
[B]Required firmware:[/B] N9750ZSU6HZE1, Android 12
[B]Status:[/B] Tested on physical hardware

[B]This is not a custom ROM.[/B] It keeps stock HZE1 One UI and replaces only
BOOT and RECOVERY.

[SIZE=5][B]What works[/B][/SIZE]

[LIST]
[*]Normal Android boot with Magisk 30.7 and working su
[*]TWRP 3.7.1_12-HZE1-FBE-lab-13
[*]FBE /data decryption with the existing Android PIN/password
[*]Primary-user CE Keymaster authorization through a SID-validated synthetic-password HAT
[*]Custom recovery persistence after normal Android boot
[*]ADB in Android and recovery
[/LIST]

[SIZE=5][B]Main fix[/B][/SIZE]

Stock HZE1 uses two Gatekeeper authentication domains. The first HAT opens the
synthetic-password blob. TWRP must then derive the separate
sp-gk-authentication credential, verify the primary-user synthetic-password
handle, validate the second HAT against its SID, and use that HAT to authorize
the CE Keymaster operation. This release implements that complete flow.

The Magisk BOOT also stops Samsung's vendor_flash_recovery service during
early-init, preventing recovery-from-boot.p from replacing TWRP. /vendor is not
modified.

[SIZE=5][B]Installation[/B][/SIZE]

[LIST=1]
[*]Back up everything and unlock the bootloader. This wipes data and permanently trips Knox.
[*]Verify model SM-N9750 and build N9750ZSU6HZE1.
[*]Verify SHA256SUMS from the release.
[*]Enter Download Mode and run the included flash-heimdall.sh --flash-no-wipe, or flash the published BOOT and RECOVERY images together with Heimdall and --no-reboot. This does not touch USERDATA when the bootloader is already unlocked.
[*]Immediately boot TWRP with USB connected and Volume Up + Side/Power.
[*]Enter the Android PIN and confirm that internal storage is decrypted.
[*]Reboot System and install the official Magisk 30.7 manager APK.
[/LIST]

[B]TWRP-only/no-wipe mode:[/B] on an already-unlocked exact HZE1 device, run
[CODE]./flash-heimdall.sh --twrp-only-no-wipe[/CODE]
This flashes RECOVERY only and leaves BOOT and USERDATA untouched. On stock
BOOT, Samsung may restore stock recovery after the next Android boot. The first
bootloader unlock itself always wipes data; there is no supported bypass.

[B]Downloads, full instructions, sources and changelog:[/B]
https://github.com/Kaktusoff/SM-N9750-HZE1-TWRP-FBE

[B]Release:[/B]
https://github.com/Kaktusoff/SM-N9750-HZE1-TWRP-FBE/releases/tag/v1.0.1

[SIZE=5][B]Warning[/B][/SIZE]

Do not flash on SM-N975F, SM-N976B, d2s, d2x, another bootloader revision, or
another firmware. Keep the complete exact HZE1 stock firmware ready for
rollback. Never relock the bootloader while custom partitions remain.

[SIZE=5][B]Optional tested stack[/B][/SIZE]

Integrity Box v41 + Tricky Store v1.4.1, Shamiko v1.2.5, Vector v2.2 + HMA
3.8.3, YouTube ReVanced Extended 20.51.39, and YouTube Music ReVanced Extended
9.15.51. These third-party files are not redistributed; upstream links and
configuration notes are in POST_INSTALL_ROOT.md.

[SIZE=5][B]Support the project[/B][/SIZE]

[B]Visa T-Bank:[/B] 4377 7278 0483 9954
[B]USDT on TON:[/B] UQAT_xqILzlNaVgnkqqpHC2v5MouL6jdhZArOAmE6TeJjo3R

Please verify the TON network and the complete address before sending.
