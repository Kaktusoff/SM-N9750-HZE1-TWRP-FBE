# Troubleshooting

## TWRP says failed to decrypt

- Confirm the exact firmware is `N9750ZSU6HZE1`.
- Use the current Android PIN/password, not the Samsung account password.
- Do not format `/data` as a first response.
- Capture `/tmp/recovery.log`, `dmesg`, and `getprop` through ADB.

## Android replaced TWRP with stock recovery

Both published images must be flashed as a pair. The recovery-survival rule is
inside the published Magisk BOOT. Booting a stock BOOT starts
`vendor_flash_recovery`, which reconstructs stock recovery from
`/vendor/recovery-from-boot.p`.

## Android does not boot

Return to Download Mode and flash the complete exact HZE1 stock firmware. Do not
relock the bootloader while a custom partition may remain.

## Magisk app is visible to another app

Use Magisk's built-in **Hide the Magisk app** function. It installs a neutral
label with a random package name. Configure HMA only for the applications that
need package-list filtering.

## An app that needs root says root is missing

Remove that app from Magisk's DenyList/Shamiko blacklist, force-stop it, and
start it again. Root permission and root visibility are separate controls. VPN
Hotspot is a concrete example: it must have an `ALLOW` policy and must not be in
the hiding list.

## Play Integrity result changed

Remote Google policy, fingerprints and attestation material change over time.
Update or troubleshoot Integrity Box/Tricky Store from their upstream projects;
the BOOT and RECOVERY images cannot guarantee an integrity verdict.

Both the Integrity Box v41 installer and its Action invoke the network updater
intended to update `/data/adb/tricky_store/keybox.xml` directly. Complete the
pre-install backup and external-state guard in `POST_INSTALL_ROOT.md`, then check
`/data/adb/Box-Brain/Integrity-Box-Logs/keybox.log` for a successful update and
verify that the destination file is non-empty and changed. If download or
decode failed, do not trust the installer/Action completion message. Retry only
with stable Internet and after reviewing the documented trust warning. Follow
the backup-first manual fallback; never post or attach the keybox itself.

## T-Pay works but T-Bank fingerprint sign-in is missing

On the tested T-Bank `8.2.2`, the app-side MIAF detector checks for
`/storage/emulated/0/TWRP`. Even an empty directory can hide biometric sign-in
while T-Pay and all three Play Integrity verdicts continue to work.

Keep Magisk Alpha's built-in Zygisk and Enforce DenyList enabled, keep
`com.idamob.tinkoff.android` in DenyList, and keep Shamiko disabled. Then run
`scripts/fix-tbank-biometric.sh` or `scripts/fix-tbank-biometric.ps1`. The
helpers force-stop only T-Bank and move the full directory to a unique path
under `/sdcard/RecoveryBackups`; they do not delete backups. TWRP can recreate
the directory, so repeat the check after every recovery session.

The helpers require Android Platform Tools, USB debugging, and an accepted RSA
authorization for the connected computer. Odin itself does not require USB
debugging. `adb devices` must show exactly one device as `device`, not
`unauthorized`.

Do not clear T-Bank data or reinstall the app while T-Pay/cards are working.
That does not remove this filesystem signal and may require payment-token
provisioning again.
