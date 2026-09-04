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

