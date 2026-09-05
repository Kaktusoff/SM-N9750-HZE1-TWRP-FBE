[SIZE=6][B]SM-N9750 HZE1: TWRP FBE + Magisk Alpha — v1.0.1[/B][/SIZE]

[B]Device:[/B] Samsung Galaxy Note10+ Snapdragon, SM-N9750 / d2q
[B]Required base:[/B] N9750ZSU6HZE1, Android 12
[B]Status:[/B] BOOT and RECOVERY tested on physical hardware

[B]This is not a custom ROM.[/B] Stock One UI remains installed; only BOOT and
RECOVERY are replaced. The existing v1.0.1 publication was fully replaced in
place; no new release was created. v1.0.0 is withdrawn.

[SIZE=5][B]Why the root image changed[/B][/SIZE]

Official Magisk 30.7 provided working root and green Play Integrity verdicts,
but T-Pay still detected the environment and reported that the service was
unavailable. On the same phone, switching to Magisk Alpha
[CODE]e8a58776-alpha (30700)[/CODE] made T-Pay available and a card was added.

The second Alpha patch had removed the project's TWRP-survival rule. v1.0.1
merges both requirements: the known-good Alpha normal boot and
[CODE]overlay.d/twrp-survival.rc[/CODE], which stops Samsung's
[CODE]vendor_flash_recovery[/CODE] service during early init without modifying
/vendor.

[SIZE=5][B]Physical-device verification[/B][/SIZE]

[LIST]
[*]Normal Android boot, Magisk Alpha 30700, and working su
[*]TWRP 3.7.1_12-HZE1-FBE-lab-13
[*]FBE /data decryption with the existing Android PIN/password
[*]SID-validated synthetic-password / Gatekeeper / Keymaster CE flow
[*]Complete Android → TWRP → Android cycle with the new BOOT
[*]Persistent custom recovery after Android boot
[*]BOOT read-back: 027447589dc1845d65d6018df5322d54b01410e939a441e0fdcf63ae9c12a8c5
[*]RECOVERY read-back: d8b050f0d342abde7339a95c5a255098a004399ff1ec78d33b0b151cf2967415
[*]YouTube RVX 20.51.39 and YouTube Music RVX 9.15.51 enabled and launch-tested
[*]Known-good banking profile: three green Play Integrity verdicts, T-Pay available, card added
[*]T-Bank 8.2.2 fingerprint sign-in restored without clearing app data; T-Pay and the provisioned card remained intact
[/LIST]

[SIZE=5][B]No-wipe installation[/B][/SIZE]

The first Samsung bootloader unlock always wipes data and trips Knox. No-wipe
applies only after the bootloader is already unlocked on exact HZE1.

[B]Linux / Heimdall:[/B]
[CODE]./flash-heimdall.sh --flash-no-wipe[/CODE]
flashes BOOT+RECOVERY. Use
[CODE]./flash-heimdall.sh --twrp-only-no-wipe[/CODE]
for RECOVERY only; stock BOOT may restore stock recovery.

[B]Windows / Odin 3.14.4:[/B] choose one AP package:
[LIST]
[*]AP_SM-N9750_HZE1_TWRP-Magisk-Alpha_v1.0.1.tar.md5 — BOOT+RECOVERY
[*]AP_SM-N9750_HZE1_TWRP-only_v1.0.1.tar.md5 — RECOVERY only
[/LIST]

Leave BL, CP, CSC, and USERDATA empty. Disable Auto Reboot, leave F. Reset Time
enabled, and never use Re-Partition, Nand Erase All, Flash Lock, or PIT. After
green PASS!, force-exit Download Mode and immediately boot TWRP while USB stays
connected.

[CODE]
aa12bed3104f48bdea7e7b18a26b72efe3f249237fbc18fdbfad9a483ec1cbd2  AP_SM-N9750_HZE1_TWRP-Magisk-Alpha_v1.0.1.tar.md5
363f8272d86450017ae7488f9f5c28976bbfc664886159de1040339200bd4206  AP_SM-N9750_HZE1_TWRP-only_v1.0.1.tar.md5
6d4d523e9e298717a224229d0b6f3e4bcf4141855b4eb98c913280025f549fc3  TBank-biometric-fix-v1.0.1.zip
[/CODE]

Neither AP archive contains USERDATA, SUPER, PIT, CSC, or modem images.

[SIZE=5][B]Known-good banking profile[/B][/SIZE]

[LIST]
[*]Magisk Alpha e8a58776 / 30700
[*]Built-in Zygisk enabled
[*]DenyList enabled
[*]Play Integrity Fork v18
[*]Tricky Store v1.4.1; the successful T-Pay result used build 248-3b07ee3
[/LIST]

Magisk's [B]Hide the Magisk app[/B] function is applied with a neutral random
manager name/package, which is intentionally not published. Enforce DenyList
remains enabled.

Existing v1.0.1 users: install/open Alpha from the full release package and
confirm working root, then remove [B]only[/B] the legacy official manager APK with
[CODE]adb uninstall com.topjohnwu.magisk[/CODE]. If that manager was hidden,
restore its app name first or remove the exact old app through Android App
info. Never choose Complete uninstall, which removes Magisk/root rather than
only the obsolete manager app. The ADB command requires current Platform Tools,
temporarily enabled USB debugging, and the accepted computer RSA prompt.

Shamiko 1.2.5, Vector 2.2, and Zygisk Next 1.2.9.1 are [B]disabled[/B] in the
working bank-first profile. HMA 3.8.3 does not hook apps without active Vector.
This is intentional: unnecessary Zygisk/Xposed hooks increased the detection
surface.

Integrity Box v41 and PIF v18 share the module id
[CODE]playintegrityfix[/CODE] and replace each other. Integrity Box can refresh
keybox/fingerprint material before PIF v18 is installed. Both its installer and
Action invoke a network updater designed to write directly to
[CODE]/data/adb/tricky_store/keybox.xml[/CODE]. The documented pre-install
backup/external-state guard, keybox log, and resulting non-empty file must be
verified; the reference phone required a backed-up manual replacement with the
freshly obtained file.
No shared keybox, fixed fingerprint, Magisk database, banking-app data, or
modified Google APK is included. The public official Tricky Store build at
release time is 245; it is not claimed to reproduce the closed build 248 result.

Install PIF v18 directly over Integrity Box; do not uninstall Integrity Box
first because its uninstaller deletes Tricky Store keybox/targets. This PIF can
also inherit that old [CODE]uninstall.sh[/CODE]; the signature-checked removal
command and private backup procedure are in [CODE]POST_INSTALL_ROOT.md[/CODE].

[CODE]
com.google.android.gms!
com.google.android.gsf
com.android.vending
com.idamob.tinkoff.android!
io.github.vvb2060.keyattestation!
[/CODE]

These are the exact reference-phone Tricky Store targets; do not append
[CODE]![/CODE] to every package.

[B]Separate T-Bank 8.2.2 fingerprint trigger:[/B] the app checks
[CODE]/storage/emulated/0/TWRP[/CODE]. Even an empty directory removed the
biometric-sign-in option while T-Pay kept working. After using recovery, run
the helpers and bilingual quick guide from the full package or the separate
[CODE]TBank-biometric-fix-v1.0.1.zip[/CODE]. The unprivileged ADB helper force-stops
only T-Bank and moves the complete directory to a unique name under
[CODE]/sdcard/RecoveryBackups[/CODE], without deleting or overwriting backups.
The helper needs current Android Platform Tools, temporarily enabled USB
debugging, and an accepted computer RSA prompt; Odin itself does not need USB
debugging. If Windows blocks the script, run
[CODE]powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\fix-tbank-biometric.ps1[/CODE]
once without changing the system policy. TWRP can recreate the directory. Do
not clear or reinstall the bank app for this correction.

Server-side banking and Play Integrity rules may change. The successful result
on September 5, 2026 is not a permanent guarantee.

[B]Repository, full archive, RU/EN guides, sources and changelog:[/B]
https://github.com/Kaktusoff/SM-N9750-HZE1-TWRP-FBE

[B]Only supported release:[/B]
https://github.com/Kaktusoff/SM-N9750-HZE1-TWRP-FBE/releases/tag/v1.0.1

[SIZE=5][B]Warning[/B][/SIZE]

Do not flash on SM-N975F, SM-N976B, d2s, d2x, another bootloader revision, or
another firmware. Never relock while custom partitions are installed.

[SIZE=5][B]Support the project[/B][/SIZE]

[B]Visa T-Bank:[/B] 4377 7278 0483 9954
[B]USDT on TON:[/B] UQAT_xqILzlNaVgnkqqpHC2v5MouL6jdhZArOAmE6TeJjo3R

Verify the TON network and the complete address before sending.
