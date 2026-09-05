# Installation from stock HZE1

## 1. Read this first

This procedure is only for `SM-N9750` on `N9750ZSU6HZE1`. Bootloader unlock
performs a factory reset and permanently trips Knox. Charge the phone, back up
all data, and keep the complete HZE1 stock firmware available for recovery.

Linux users can use the guarded Heimdall installer. Ready-to-flash `AP_*.tar.md5`
packages are published for Windows/Odin. They contain the same device-tested
BOOT and RECOVERY images; their MD5 footer, LZ4 streams, archive structure, and
decompressed output are validated automatically. The Windows/Odin transport
path has not yet been separately reflashed on hardware, so do not skip the
model, base-firmware, and SHA-256 checks.

## 2. Unlock the bootloader

Skip this section only if Download Mode already reports an unlocked bootloader.

1. In Android, enable Developer options and **OEM unlocking**.
2. Power the phone off.
3. Hold both volume buttons while connecting USB to the computer to enter the
   Samsung unlock/download screen.
4. Follow the on-screen long-press Volume Up instruction to unlock the
   bootloader. Confirm the data wipe.
5. Complete the initial Android setup, reconnect to the Internet, enable
   Developer options again, and verify that OEM unlocking is shown as already
   unlocked.

Never relock the bootloader while custom BOOT or RECOVERY is installed.

## 3. Verify the release

Extract the release package. On Linux, from the directory containing the images:

```bash
sha256sum -c SHA256SUMS
```

Every listed file must say `OK`. Also verify the model and firmware in Android.
These ADB checks and the later manager migration require current Android
Platform Tools, temporarily enabled USB debugging, an unlocked screen, and the
computer's accepted RSA prompt; Odin flashing itself does not:

```bash
adb shell getprop ro.product.model
adb shell getprop ro.build.version.incremental
```

Expected output is `SM-N9750` and `N9750ZSU6HZE1`.

On Windows, open PowerShell in the Odin package directory and run:

```powershell
Get-FileHash .\AP_SM-N9750_HZE1_TWRP-Magisk-Alpha_v1.0.1.tar.md5 -Algorithm SHA256
Get-FileHash .\AP_SM-N9750_HZE1_TWRP-only_v1.0.1.tar.md5 -Algorithm SHA256
```

Compare both values with the adjacent `SHA256SUMS-ODIN.txt` file.

```text
aa12bed3104f48bdea7e7b18a26b72efe3f249237fbc18fdbfad9a483ec1cbd2  AP_SM-N9750_HZE1_TWRP-Magisk-Alpha_v1.0.1.tar.md5
363f8272d86450017ae7488f9f5c28976bbfc664886159de1040339200bd4206  AP_SM-N9750_HZE1_TWRP-only_v1.0.1.tar.md5
```

## 4. Choose the flashing mode

Neither mode below formats or flashes `USERDATA`. This is a no-wipe upgrade only
when Download Mode already reports an unlocked bootloader. The first Samsung
bootloader unlock always performs a factory reset and cannot be made no-wipe by
this package.

For persistent TWRP plus Magisk Alpha normal boot, use:

```bash
./flash-heimdall.sh --flash-no-wipe
```

This flashes only `BOOT` and `RECOVERY`; existing Android data is preserved on
the exact supported HZE1 base. `--flash` remains an alias for this paired mode.
On Windows, select `AP_SM-N9750_HZE1_TWRP-Magisk-Alpha_v1.0.1.tar.md5` in Odin's AP
field.

To install only TWRP without touching `BOOT` or user data, use:

```bash
./flash-heimdall.sh --twrp-only-no-wipe
```

Recovery-only mode is useful for testing or accessing existing encrypted data.
On an otherwise stock BOOT, Samsung can restore stock recovery after the next
normal Android boot. For persistent TWRP, use the paired mode above.
On Windows, recovery-only mode uses
`AP_SM-N9750_HZE1_TWRP-only_v1.0.1.tar.md5`.

## 5. Flash with Heimdall on Linux

Enter Download Mode, connect USB, and verify detection:

```bash
heimdall detect
```

Use the included guarded installer:

```bash
./flash-heimdall.sh --flash-no-wipe
```

Or flash manually:

```bash
heimdall flash \
  --BOOT SM-N9750-HZE1-Magisk-Alpha-30700-BOOT-v1.0.1.img \
  --RECOVERY SM-N9750-HZE1-TWRP-3.7.1_12-FBE-v1.0.1.img \
  --no-reboot
```

After Heimdall reports success, hold Volume Down + Side/Power until the display
turns black, then immediately switch to Volume Up + Side/Power while USB remains
connected. Release the buttons when TWRP appears.

## 6. Flash with Odin on Windows

1. Install Samsung USB Driver and extract Odin `3.14.4`.
2. Close Smart Switch, Kies, and other software that may claim the USB port.
   Use a reliable cable and a direct PC USB port, not a hub.
3. Enter Download Mode: power off, hold both volume buttons, connect USB, and
   confirm with Volume Up.
4. Confirm that Odin shows an active `ID:COM` port and `Added!!`.
5. Click **AP** and choose exactly one package:

   - `AP_SM-N9750_HZE1_TWRP-Magisk-Alpha_v1.0.1.tar.md5` for persistent TWRP + Magisk Alpha;
   - `AP_SM-N9750_HZE1_TWRP-only_v1.0.1.tar.md5` for TWRP only.

6. Leave **BL**, **CP**, **CSC**, and **USERDATA** empty. Under **Options**,
   disable **Auto Reboot**, leave **F. Reset Time** enabled, and never enable
   **Re-Partition**, **Nand Erase All**, **Flash Lock**, or **DeviceInfo**. Do not
   select a PIT file.
7. Click **Start**, keep USB connected, and wait for green `PASS!`. If Odin says
   `FAIL!`, save its Log and do not blindly repeat the flash.
8. After `PASS!`, hold Volume Down + Side/Power until the screen turns black,
   then immediately switch to Volume Up + Side/Power with USB still connected.
   Release the buttons when TWRP appears.

The packages contain only `boot` and/or `recovery`; they do not include
`userdata`, `super`, `vbmeta`, PIT, CSC, or modem files. Existing data is
therefore preserved on an already-unlocked device running exact HZE1. The first
bootloader unlock still always performs a factory reset.

## 7. First TWRP boot

1. Confirm the version is `3.7.1_12-HZE1-FBE-lab-13`.
2. Enter the same PIN/password used by Android.
3. Verify that internal storage shows normal directory names and sizes.
4. Do not format `/data`. A decrypt failure on the exact HZE1 base is a bug to
   diagnose, not a reason to wipe user data.
5. Select **Reboot > System**.

Android should now boot normally. The patched BOOT stops Samsung's
`vendor_flash_recovery` service during early init, so the custom recovery is not
reconstructed back to stock.

If recovery-only mode was selected, choosing **Reboot > System** does not add
root and a stock BOOT may restore stock recovery. The steps below apply to the
paired BOOT+RECOVERY mode.

## 8. Install the Magisk Alpha app

Install the exact APK included with v1.0.1:

```bash
adb install root-tools/Magisk-Alpha-e8a58776-30700.apk
```

The app and `adb shell su -c 'magisk -v'` must report `e8a58776-alpha` with
working root.

When upgrading from the originally published v1.0.1, remove the old official
30.7 **manager APK only** after Alpha has opened and confirmed root. The two
managers use different package IDs and otherwise remain installed side by side:

```bash
adb shell pm path com.topjohnwu.magisk
adb uninstall com.topjohnwu.magisk
```

If the old manager was hidden under a randomized package, use that old app's
**Restore the Magisk app** function first, or uninstall the exact old app from
Android App info. Do not guess a random package and do not choose **Uninstall
Magisk/Complete uninstall**: root belongs to the patched BOOT and must remain.
Removing only `com.topjohnwu.magisk` does not remove Alpha root or modules.

Now use Alpha's **Hide the Magisk app** with a new neutral random manager
package. Use Magisk's built-in Zygisk and **Enforce DenyList**; leave
Zygisk Next and Shamiko disabled for the reference bank-first profile. Do not
install the official 30.7 manager over this image; it belongs to the withdrawn
original BOOT. See
[POST_INSTALL_ROOT.md](POST_INSTALL_ROOT.md) for the known-good banking profile
and module order.

## 9. T-Bank after using TWRP

TWRP can create `/sdcard/TWRP` in shared storage. T-Bank `8.2.2` treats even an
empty directory as a modified-environment signal: T-Pay can keep working while
fingerprint sign-in disappears. After leaving recovery and before opening the
bank app, run:

```bash
./scripts/fix-tbank-biometric.sh
```

or in Windows PowerShell:

```powershell
.\scripts\fix-tbank-biometric.ps1
```

Install the current Android Platform Tools before running either helper. Odin
does not need USB debugging, but the helper does: boot Android, temporarily
enable USB debugging, connect and unlock the phone, accept the computer RSA
prompt, then check that `adb devices` shows exactly one line with state
`device` rather than `unauthorized`. On Windows, if PowerShell execution policy
blocks the script, run it once without changing the system policy:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\fix-tbank-biometric.ps1
```

The helper uses unprivileged ADB, force-stops only T-Bank, and moves the entire
directory under a unique name in `/sdcard/RecoveryBackups`. It never deletes or
overwrites backups. Do not clear or reinstall T-Bank for this fix. See
[POST_INSTALL_ROOT.md](POST_INSTALL_ROOT.md) for the full explanation.

## 10. Entering recovery later

Power the phone off. Keep USB connected, then hold Volume Up + Side/Power until
TWRP appears.

## 11. Rollback

The safest complete rollback is to flash the full, exact
`N9750ZSU6HZE1` Samsung firmware. Flashing only stock BOOT restores normal
unrooted Android, but the stock vendor service will then restore stock recovery
on the next boot.

Relock the bootloader only after every partition has been returned to complete
stock firmware and the phone has booted successfully. Relocking also wipes data;
Knox remains tripped.
